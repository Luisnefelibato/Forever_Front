import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:dio/dio.dart';
import '../config/onfido_config.dart';

/// Servicio para manejar la integración con Onfido SDK
class OnfidoService {
  
  // Token temporal para testing (puede ser sobrescrito)
  static String? _customApiToken;
  
  /// Permite establecer un token personalizado para testing
  static void setCustomApiToken(String? token) {
    _customApiToken = token;
    print('🔧 Token personalizado configurado: ${token != null ? "${token.substring(0, 10)}...${token.substring(token.length - 5)}" : "null"}');
  }
  
  /// Obtiene el token a usar (personalizado o el de configuración)
  static String get _currentApiToken {
    return _customApiToken?.trim() ?? OnfidoConfig.apiToken.trim();
  }
  
  static Dio get _dio {
    // Select base URL by region
    String baseUrl;
    switch (OnfidoConfig.region.toUpperCase()) {
      case 'US':
        baseUrl = 'https://api.us.onfido.com/v3.6';
        break;
      case 'EU':
        baseUrl = 'https://api.eu.onfido.com/v3.6';
        break;
      default:
        baseUrl = 'https://api.onfido.com/v3.6';
    }

    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    // Agregar interceptor para el header de autorización
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _currentApiToken;
        
        // Verificar que el token no esté vacío
        if (token.isEmpty) {
          print('❌ ERROR: API Token está vacío!');
          print('   - Token de configuración: ${OnfidoConfig.apiToken}');
          print('   - Token personalizado: $_customApiToken');
          handler.reject(DioException(
            requestOptions: options,
            error: 'API Token is empty',
          ));
          return;
        }
        
        // Formato correcto de autorización para Onfido API v3.6: "Token token=<TOKEN>"
        // Sin espacios extras, exactamente: "Token token=EYFA0st4yu..."
        // Limpiar cualquier espacio en blanco al inicio/fin del token
        final cleanToken = token.trim();
        final authHeader = 'Token token=$cleanToken';
        options.headers['Authorization'] = authHeader;
        
        print('🔑 Request a Onfido:');
        print('   - URL: ${options.baseUrl}${options.path}');
        print('   - Method: ${options.method}');
        print('   - Authorization Header: ${authHeader.substring(0, 30)}...');
        print('   - Token Length: ${token.length} caracteres');
        print('   - Token Preview: ${token.substring(0, 20)}...${token.substring(token.length - 5)}');
        print('   - Using Custom Token: ${_customApiToken != null}');
        print('   - Region: ${OnfidoConfig.region}');
        print('   - Data: ${options.data}');
        handler.next(options);
      },
      onError: (error, handler) {
        print('❌ Error en request a Onfido:');
        print('   - Status: ${error.response?.statusCode}');
        print('   - Message: ${error.message}');
        print('   - Response: ${error.response?.data}');
        handler.next(error);
      },
    ));
    
    return dio;
  }
  
  /// Inicia el proceso de verificación con Onfido usando Studio Workflow
  static Future<bool> startVerification({
    required String sdkToken,
    required String workflowRunId,
  }) async {
    try {
      print('🔐 Inicializando Onfido SDK...');
      final tokenPreview = sdkToken.length > 20 
          ? '${sdkToken.substring(0, 20)}...' 
          : sdkToken;
      print('   - SDK Token: $tokenPreview');
      print('   - Workflow Run ID: $workflowRunId');
      
      // Crear instancia del SDK de Onfido
      final onfido = Onfido(
        sdkToken: sdkToken,
        onfidoTheme: OnfidoTheme.AUTOMATIC,
        nfcOption: NFCOptions.OPTIONAL,
      );

      print('▶️ Iniciando workflow de Onfido...');

      // Iniciar el workflow de Studio
      // Este método no retorna hasta que el usuario complete o cancele el proceso
      await onfido.startWorkflow(workflowRunId);
      
      // Si llegamos aquí, la verificación fue completada exitosamente
      print('✅ Verificación de Onfido completada exitosamente');
      return true;
    } catch (e) {
      // El SDK de Onfido puede lanzar excepciones en diferentes casos:
      // 1. Usuario canceló el proceso
      // 2. Error de red
      // 3. Error del SDK
      print('❌ Onfido SDK error: $e');
      print('   - Tipo de error: ${e.runtimeType}');
      
      // Verificar si es una cancelación del usuario
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancel') || 
          errorString.contains('user cancelled') ||
          errorString.contains('abort')) {
        print('⚠️ Usuario canceló la verificación');
        return false;
      }
      
      // Para otros errores, también retornamos false
      // pero el mensaje se mostrará en la pantalla de pago
      return false;
    }
  }

  /// Inicia el proceso de verificación con Onfido usando configuración manual
  static Future<bool> startManualVerification({
    required String sdkToken,
    required String applicantId,
  }) async {
    try {
      // Crear instancia del SDK de Onfido
      final onfido = Onfido(
        sdkToken: sdkToken,
        onfidoTheme: OnfidoTheme.AUTOMATIC,
        nfcOption: NFCOptions.OPTIONAL,
      );

      // Iniciar el flujo manual
      await onfido.start(
        flowSteps: FlowSteps(
          welcome: true,
          documentCapture: DocumentCapture(),
          faceCapture: FaceCapture.photo(
            withIntroScreen: true,
          ),
        ),
      );
      
      // Si llegamos aquí, la verificación fue exitosa
      print('Verification completed successfully');
      return true;
    } catch (e) {
      print('Onfido SDK error: $e');
      return false;
    }
  }

  /// Crea un Applicant en Onfido y retorna el Applicant ID
  static Future<String> createApplicant() async {
    try {
      print('📝 Creando Applicant en Onfido...');
      
      final response = await _dio.post(
        '/applicants',
        data: {
          'first_name': 'Test',
          'last_name': 'User',
        },
      );
      
      if (response.statusCode == 201) {
        final applicantId = response.data['id'] as String;
        print('✅ Applicant creado: $applicantId');
        return applicantId;
      } else {
        throw Exception('Failed to create applicant: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creando Applicant: $e');
      rethrow;
    }
  }

  /// Crea un Workflow Run en Onfido y retorna SDK token y Workflow Run ID
  static Future<Map<String, String>> createWorkflowRun({
    required String applicantId,
  }) async {
    try {
      print('📝 Creando Workflow Run en Onfido...');
      
      final response = await _dio.post(
        '/workflow_runs',
        data: {
          'applicant_id': applicantId,
          'workflow_id': OnfidoConfig.workflowId,
        },
      );
      
      if (response.statusCode == 201) {
        final workflowRunId = response.data['id'] as String;
        final sdkToken = response.data['sdk_token'] as String;
        
        print('✅ Workflow Run creado: $workflowRunId');
        print('✅ SDK Token obtenido: ${sdkToken.substring(0, 20)}...');
        
        return {
          'workflow_run_id': workflowRunId,
          'sdk_token': sdkToken,
          'applicant_id': applicantId,
        };
      } else {
        throw Exception('Failed to create workflow run: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creando Workflow Run: $e');
      if (e is DioException && e.response != null) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Data: ${e.response?.data}');
        // Fallback: si Workflows no está disponible (404), intentar SDK token manual
        if (e.response?.statusCode == 404) {
          print('➡️ Fallback a SDK token manual (sin Workflows)');
          final sdkToken = await createSdkTokenManual(applicantId: applicantId);
          return {
            'sdk_token': sdkToken,
            'applicant_id': applicantId,
          };
        }
      }
      rethrow;
    }
  }

  /// Crea un SDK token sin Workflows (modo manual)
  static Future<String> createSdkTokenManual({
    required String applicantId,
  }) async {
    try {
      print('📝 Creando SDK token manual para applicant: $applicantId');
      final response = await _dio.post(
        '/sdk_token',
        data: {
          'applicant_id': applicantId,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = response.data['token'] as String? ?? response.data['sdk_token'] as String?;
        if (token == null || token.isEmpty) throw Exception('SDK token vacío');
        print('✅ SDK token manual obtenido: ${token.substring(0, 20)}...');
        return token;
      }
      throw Exception('Fallo creando SDK token manual: ${response.statusCode}');
    } catch (e) {
      print('❌ Error creando SDK token manual: $e');
      rethrow;
    }
  }

  /// Genera un SDK token para Onfido usando la API real
  static Future<String> generateSdkToken({
    required String userId,
  }) async {
    try {
      // Crear Applicant primero
      final applicantId = await createApplicant();
      
      // Crear Workflow Run que retorna el SDK token
      final workflowData = await createWorkflowRun(applicantId: applicantId);
      
      return workflowData['sdk_token']!;
    } catch (e) {
      print('⚠️ Error generando SDK token real, usando temporal: $e');
      // Fallback: intentar SDK token manual
      try {
        final fallbackApplicant = await createApplicant();
        final manualToken = await createSdkTokenManual(applicantId: fallbackApplicant);
        return manualToken;
      } catch (_) {}
      // Último recurso: token temporal (no funcionará con el SDK real)
      return 'sdk_token_temp_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Genera un Workflow Run ID para Onfido usando la API real
  static Future<String> generateWorkflowRunId({
    required String userId,
  }) async {
    try {
      // Crear Applicant primero
      final applicantId = await createApplicant();
      
      // Crear Workflow Run que retorna el workflow run ID
      final workflowData = await createWorkflowRun(applicantId: applicantId);
      
      if (workflowData.containsKey('workflow_run_id')) {
        return workflowData['workflow_run_id']!;
      }
      // Si no hay workflow_run_id (modo manual), no es aplicable
      throw Exception('Workflow Run ID no disponible (modo manual)');
    } catch (e) {
      print('⚠️ Error generando Workflow Run ID real, usando temporal: $e');
      // Fallback a ID temporal si falla la API
      return 'wfr_temp_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
  
  /// Obtiene el SDK token de un Workflow Run existente
  static Future<Map<String, String>> getSdkTokenFromExistingWorkflowRun({
    required String workflowRunId,
  }) async {
    try {
      print('📝 Obteniendo SDK token del Workflow Run existente: $workflowRunId');
      
      final response = await _dio.get('/workflow_runs/$workflowRunId');
      
      if (response.statusCode == 200) {
        // El SDK token podría no estar en la respuesta GET, pero podemos intentar obtenerlo
        // Si el workflow run aún está activo, podemos crear un nuevo SDK token
        // O mejor aún, crear un nuevo workflow run con el mismo applicant
        print('✅ Workflow Run encontrado');
        final applicantId = response.data['applicant_id'] as String;
        
        // Crear un nuevo workflow run para obtener SDK token fresco
        print('📝 Creando nuevo Workflow Run para obtener SDK token...');
        final workflowData = await createWorkflowRun(applicantId: applicantId);
        
        return workflowData;
      } else {
        throw Exception('Failed to get workflow run: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error obteniendo SDK token del workflow run existente: $e');
      rethrow;
    }
  }

  /// Crea un Workflow Run usando un Applicant ID existente
  static Future<Map<String, String>> createWorkflowRunWithExistingApplicant({
    required String applicantId,
  }) async {
    try {
      print('📝 Creando Workflow Run con Applicant existente: $applicantId');
      return await createWorkflowRun(applicantId: applicantId);
    } catch (e) {
      print('❌ Error creando Workflow Run con Applicant existente: $e');
      rethrow;
    }
  }

  /// Crea un Applicant y luego intenta crear Workflow Run; si falla, retorna SDK token manual
  static Future<Map<String, String>> createApplicantAndWorkflowRun() async {
    try {
      // Intentar primero usar el Applicant existente si tenemos el ID
      // Por ahora, creamos uno nuevo
      final applicantId = await createApplicant();
      final workflowData = await createWorkflowRun(applicantId: applicantId);
      return workflowData;
    } catch (e) {
      print('❌ Error creando Applicant y Workflow Run: $e');
      rethrow;
    }
  }
  
  /// Inicia verificación usando Applicant y Workflow Run existentes (para testing rápido)
  static Future<Map<String, String>> useExistingCredentials({
    String? existingApplicantId,
    String? existingWorkflowRunId,
  }) async {
    try {
      if (existingApplicantId != null) {
        print('📝 Usando Applicant existente: $existingApplicantId');
        // Crear nuevo workflow run con applicant existente para obtener SDK token fresco
        return await createWorkflowRunWithExistingApplicant(
          applicantId: existingApplicantId,
        );
      } else if (existingWorkflowRunId != null) {
        print('📝 Intentando obtener SDK token del Workflow Run existente: $existingWorkflowRunId');
        return await getSdkTokenFromExistingWorkflowRun(
          workflowRunId: existingWorkflowRunId,
        );
      } else {
        // Crear nuevo
        return await createApplicantAndWorkflowRun();
      }
    } catch (e) {
      print('❌ Error usando credenciales existentes: $e');
      rethrow;
    }
  }

  /// TEST: Verifica la conexión con la API de Onfido y obtiene tokens reales
  static Future<Map<String, dynamic>> testOnfidoConnection() async {
    try {
      print('🧪 TEST: Verificando conexión con Onfido API...');
      print('   - API Token: ${OnfidoConfig.apiToken.substring(0, 10)}...${OnfidoConfig.apiToken.substring(OnfidoConfig.apiToken.length - 5)}');
      print('   - Token Length: ${OnfidoConfig.apiToken.length} caracteres');
      print('   - Workflow ID: ${OnfidoConfig.workflowId}');
      print('   - Base URL: https://api.onfido.com/v3.6');
      
      // Verificar formato del token
      if (OnfidoConfig.apiToken.isEmpty) {
        throw Exception('API Token is empty. Please check OnfidoConfig.apiToken');
      }
      
      if (OnfidoConfig.apiToken.length < 20) {
        print('⚠️ WARNING: Token parece muy corto (${OnfidoConfig.apiToken.length} caracteres)');
      }
      
      // Test 1: Crear Applicant
      print('\n📝 TEST 1: Creando Applicant...');
      final applicantId = await createApplicant();
      print('✅ Applicant creado exitosamente: $applicantId');
      
      // Test 2: Crear Workflow Run
      print('\n📝 TEST 2: Creando Workflow Run...');
      final workflowData = await createWorkflowRun(applicantId: applicantId);
      print('✅ Workflow Run creado exitosamente');
      
      final sdkToken = workflowData['sdk_token']!;
      final workflowRunId = workflowData['workflow_run_id']!;
      
      print('\n✅ TEST COMPLETADO EXITOSAMENTE:');
      print('   - Applicant ID: $applicantId');
      print('   - SDK Token: ${sdkToken.substring(0, 30)}...');
      print('   - SDK Token Length: ${sdkToken.length} caracteres');
      print('   - Workflow Run ID: $workflowRunId');
      
      return {
        'success': true,
        'applicant_id': applicantId,
        'sdk_token': sdkToken,
        'workflow_run_id': workflowRunId,
      };
    } catch (e) {
      print('\n❌ TEST FALLÓ:');
      print('   - Error: $e');
      print('   - Tipo: ${e.runtimeType}');
      
      if (e is DioException) {
        print('   - Status Code: ${e.response?.statusCode}');
        print('   - Status Message: ${e.response?.statusMessage}');
        print('   - Response Data: ${e.response?.data}');
        print('   - Request Path: ${e.requestOptions.path}');
        print('   - Request Data: ${e.requestOptions.data}');
        print('   - Request Headers (sin token completo):');
        final headers = Map<String, dynamic>.from(e.requestOptions.headers);
        if (headers.containsKey('Authorization')) {
          final auth = headers['Authorization'] as String;
          headers['Authorization'] = '${auth.substring(0, 20)}...[REDACTED]';
        }
        print('     $headers');
        
        // Si es error 401, dar sugerencias
        if (e.response?.statusCode == 401) {
          print('\n💡 SUGERENCIAS para error 401:');
          print('   1. Verifica que el API Token sea correcto');
          print('   2. Verifica que el token no haya expirado');
          print('   3. Verifica que tengas permisos para acceder al workflow');
          print('   4. El token debe tener formato: sin espacios al inicio/fin');
          print('   5. Revisa en Onfido Dashboard que el token esté activo');
        }
      }
      
      return {
        'success': false,
        'error': e.toString(),
        'error_type': e.runtimeType.toString(),
        'dio_error': e is DioException ? {
          'status_code': e.response?.statusCode,
          'status_message': e.response?.statusMessage,
          'response_data': e.response?.data,
          'request_path': e.requestOptions.path,
        } : null,
      };
    }
  }

  /// Inicia el proceso completo de verificación (pago + Onfido)
  static Future<bool> startCompleteVerification({
    required String userId,
    required String paymentTransactionId,
  }) async {
    try {
      print('🚀 Iniciando proceso completo de verificación...');
      
      // Paso 1: Crear Applicant y Workflow Run en Onfido para obtener credenciales reales
      // Opcional: Puedes usar Applicant ID existente: '44dd2c04-7e44-4bc8-9d49-851210200b8f'
      print('📝 Creando Applicant y Workflow Run en Onfido API...');
      
      String sdkToken;
      String workflowRunId;
      
      try {
        print('📝 Creando Applicant y Workflow Run automáticamente...');
        print('   - Usando Workflow ID: ${OnfidoConfig.workflowId}');
        
        // Crear nuevo Applicant y Workflow Run con el workflow ID configurado
        // Si Workflows no está disponible, se devolverá sdk_token manual y applicant_id
        final workflowData = await createApplicantAndWorkflowRun();
        
        sdkToken = workflowData['sdk_token']!;
        workflowRunId = workflowData['workflow_run_id'] ?? '';
        final applicantId = workflowData['applicant_id'] ?? '';
        
        print('✅ Credenciales obtenidas:');
        print('   - SDK Token: ${sdkToken.substring(0, min(30, sdkToken.length))}...');
        print('   - Workflow Run ID: ${workflowRunId.isNotEmpty ? workflowRunId : '(no disponible, modo manual)'}');
        print('   - Applicant ID: ${applicantId.isNotEmpty ? applicantId : '(no disponible)'}');
      } catch (apiError) {
        print('❌ ERROR CRÍTICO: No se pudieron obtener credenciales reales de Onfido');
        print('   - Error: $apiError');
        
        if (apiError is DioException) {
          print('   - Status: ${apiError.response?.statusCode}');
          print('   - Response: ${apiError.response?.data}');
          
          // Lanzar excepción para que se muestre en la UI
          throw Exception(
            'Failed to connect to Onfido API: ${apiError.response?.statusCode} - ${apiError.response?.data ?? apiError.message}'
          );
        }
        
        throw Exception('Failed to get Onfido credentials: $apiError');
      }
      
      // Validar que tenemos sdkToken
      if (sdkToken.isEmpty) {
        throw Exception('Invalid SDK token obtained. Token looks temporary/fake.');
      }
      
      // Paso 2: Iniciar verificación con Onfido SDK
      print('\n🔐 Iniciando verificación con Onfido SDK...');
      bool success;
      if (workflowRunId.isNotEmpty) {
        print('   - Modo Workflows');
        success = await startVerification(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
      );
      } else {
        print('   - Modo Manual (sin Workflows)');
        // Crear applicant mínimo para manual
        final fallbackApplicantId = await createApplicant();
        success = await startManualVerification(
          sdkToken: sdkToken,
          applicantId: fallbackApplicantId,
        );
      }
      
      if (success) {
        print('🎉 Verificación completada exitosamente!');
        return true;
      } else {
        print('❌ Verificación falló o fue cancelada');
        return false;
      }
    } catch (e) {
      print('💥 Error en proceso de verificación: $e');
      print('   - Tipo: ${e.runtimeType}');
      if (e is DioException) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Message: ${e.message}');
        print('   - Response: ${e.response?.data}');
      }
      // Re-lanzar para que se muestre en la UI
      rethrow;
    }
  }
  
  static int min(int a, int b) => a < b ? a : b;
}