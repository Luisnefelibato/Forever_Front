import 'package:onfido_sdk/onfido_sdk.dart';

/// Servicio para manejar la integración con Onfido SDK
class OnfidoService {
  
  /// Inicia el proceso de verificación con Onfido usando Studio Workflow
  static Future<bool> startVerification({
    required String sdkToken,
    required String workflowRunId,
  }) async {
    try {
      // Crear instancia del SDK de Onfido
      final onfido = Onfido(
        sdkToken: sdkToken,
        onfidoTheme: OnfidoTheme.AUTOMATIC,
        nfcOption: NFCOptions.OPTIONAL,
      );

      // Iniciar el workflow de Studio
      await onfido.startWorkflow(workflowRunId);
      
      // Si llegamos aquí, la verificación fue exitosa
      print('Verification completed successfully');
      return true;
    } catch (e) {
      print('Onfido SDK error: $e');
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

  /// Genera un SDK token para Onfido (simulación - en producción vendría del backend)
  static Future<String> generateSdkToken({
    required String userId,
  }) async {
    // En producción, esto debería venir del backend
    // Por ahora generamos un token simulado
    await Future<void>.delayed(const Duration(seconds: 1));
    
    return 'sdk_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Genera un Workflow Run ID para Onfido (simulación - en producción vendría del backend)
  static Future<String> generateWorkflowRunId({
    required String userId,
  }) async {
    // En producción, esto debería venir del backend
    // Por ahora generamos un ID simulado
    await Future<void>.delayed(const Duration(milliseconds: 500));
    
    return 'wfr_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Inicia el proceso completo de verificación (pago + Onfido)
  static Future<bool> startCompleteVerification({
    required String userId,
    required String paymentTransactionId,
  }) async {
    try {
      print('🚀 Iniciando proceso completo de verificación...');
      
      // Paso 1: Generar SDK token y Workflow Run ID
      print('📝 Generando credenciales de Onfido...');
      final sdkToken = await generateSdkToken(userId: userId);
      final workflowRunId = await generateWorkflowRunId(userId: userId);
      
      print('✅ Credenciales generadas:');
      print('   - SDK Token: $sdkToken');
      print('   - Workflow Run ID: $workflowRunId');
      
      // Paso 2: Iniciar verificación con Onfido
      print('🔐 Iniciando verificación con Onfido...');
      final success = await startVerification(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
      );
      
      if (success) {
        print('🎉 Verificación completada exitosamente!');
        return true;
      } else {
        print('❌ Verificación falló o fue cancelada');
        return false;
      }
    } catch (e) {
      print('💥 Error en proceso de verificación: $e');
      return false;
    }
  }
}