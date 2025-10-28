import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://3.232.35.26:8000/api/v1',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer EYFA0st4yuXDVrldNshBRtj4zfIgAoAlw89BsvnZ4IE',
    },
  ));

  print('🔍 Probando endpoints de verificación de ForeverUsInLove...\n');

  // Test 1: Verificar conectividad básica
  await testServerConnectivity(dio);

  // Test 2: Probar endpoint de crear sesión de verificación
  await testCreateVerificationSession(dio);

  // Test 3: Probar endpoint de estado de verificación
  await testVerificationStatus(dio);

  // Test 4: Probar endpoint de resultado de verificación
  await testVerificationResult(dio);

  // Test 5: Probar endpoint de confirmar verificación
  await testConfirmVerification(dio);

  // Test 6: Probar endpoint de cancelar verificación
  await testCancelVerification(dio);

  print('\n✅ Pruebas completadas');
}

Future<void> testServerConnectivity(Dio dio) async {
  print('1. 🔗 Probando conectividad del servidor...');
  try {
    final response = await dio.get('/auth/register/check-username?username=test');
    print('   ✅ Servidor accesible - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error de conectividad: $e\n');
  }
}

Future<void> testCreateVerificationSession(Dio dio) async {
  print('2. 📝 Probando crear sesión de verificación...');
  try {
    final testData = {
      'payment_transaction_id': 'test_txn_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': 'test_user_123',
      'workflow_id': '2e849672-bc5e-449a-9feb-c40ccde8b575',
      'environment': 'live',
    };

    final response = await dio.post('/verification/create-session', data: testData);
    print('   ✅ Sesión creada - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error creando sesión: $e');
    if (e is DioException && e.response != null) {
      print('   📄 Status: ${e.response?.statusCode}');
      print('   📄 Data: ${e.response?.data}\n');
    } else {
      print('   📄 Error: ${e.toString()}\n');
    }
  }
}

Future<void> testVerificationStatus(Dio dio) async {
  print('3. 📊 Probando estado de verificación...');
  try {
    final testSessionId = 'test_session_${DateTime.now().millisecondsSinceEpoch}';
    final response = await dio.get('/verification/status/$testSessionId');
    print('   ✅ Estado obtenido - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error obteniendo estado: $e');
    if (e is DioException && e.response != null) {
      print('   📄 Status: ${e.response?.statusCode}');
      print('   📄 Data: ${e.response?.data}\n');
    } else {
      print('   📄 Error: ${e.toString()}\n');
    }
  }
}

Future<void> testVerificationResult(Dio dio) async {
  print('4. 🎯 Probando resultado de verificación...');
  try {
    final testWorkflowRunId = 'test_wfr_${DateTime.now().millisecondsSinceEpoch}';
    final response = await dio.get('/verification/result/$testWorkflowRunId');
    print('   ✅ Resultado obtenido - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error obteniendo resultado: $e');
    if (e is DioException && e.response != null) {
      print('   📄 Status: ${e.response?.statusCode}');
      print('   📄 Data: ${e.response?.data}\n');
    } else {
      print('   📄 Error: ${e.toString()}\n');
    }
  }
}

Future<void> testConfirmVerification(Dio dio) async {
  print('5. ✅ Probando confirmar verificación...');
  try {
    final testData = {
      'session_id': 'test_session_${DateTime.now().millisecondsSinceEpoch}',
      'workflow_run_id': 'test_wfr_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': 'test_user_123',
      'status': 'completed',
      'completed_at': DateTime.now().toIso8601String(),
    };

    final response = await dio.post('/verification/confirm', data: testData);
    print('   ✅ Verificación confirmada - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error confirmando verificación: $e');
    if (e is DioException && e.response != null) {
      print('   📄 Status: ${e.response?.statusCode}');
      print('   📄 Data: ${e.response?.data}\n');
    } else {
      print('   📄 Error: ${e.toString()}\n');
    }
  }
}

Future<void> testCancelVerification(Dio dio) async {
  print('6. ❌ Probando cancelar verificación...');
  try {
    final testData = {
      'session_id': 'test_session_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': 'test_user_123',
      'reason': 'user_cancelled',
      'cancelled_at': DateTime.now().toIso8601String(),
    };

    final response = await dio.post('/verification/cancel', data: testData);
    print('   ✅ Verificación cancelada - Status: ${response.statusCode}');
    print('   📄 Response: ${response.data}\n');
  } catch (e) {
    print('   ❌ Error cancelando verificación: $e');
    if (e is DioException && e.response != null) {
      print('   📄 Status: ${e.response?.statusCode}');
      print('   📄 Data: ${e.response?.data}\n');
    } else {
      print('   📄 Error: ${e.toString()}\n');
    }
  }
}
