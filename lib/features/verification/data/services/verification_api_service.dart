import 'package:dio/dio.dart';
import '../config/onfido_config.dart';

/// Servicio para manejar las llamadas API del backend de ForeverUsInLove
class VerificationApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: OnfidoConfig.baseUrl,
    connectTimeout: OnfidoConfig.connectionTimeout,
    receiveTimeout: OnfidoConfig.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${OnfidoConfig.apiToken}',
    },
  ));

  /// Crea una sesión de verificación con Onfido
  static Future<Map<String, dynamic>> createVerificationSession({
    required String paymentTransactionId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/verification/create-session',
        data: {
          'payment_transaction_id': paymentTransactionId,
          'user_id': userId,
          'workflow_id': OnfidoConfig.workflowId,
          'environment': OnfidoConfig.environment,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create verification session: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Verifica el estado de una sesión de verificación
  static Future<Map<String, dynamic>> checkVerificationStatus({
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get('/verification/status/$sessionId');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to check verification status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Obtiene el resultado de una verificación completada
  static Future<Map<String, dynamic>> getVerificationResult({
    required String workflowRunId,
  }) async {
    try {
      final response = await _dio.get('/verification/result/$workflowRunId');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get verification result: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Confirma que una verificación fue completada exitosamente
  static Future<bool> confirmVerificationCompletion({
    required String sessionId,
    required String workflowRunId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/verification/confirm',
        data: {
          'session_id': sessionId,
          'workflow_run_id': workflowRunId,
          'user_id': userId,
          'status': 'completed',
          'completed_at': DateTime.now().toIso8601String(),
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Cancela una sesión de verificación
  static Future<bool> cancelVerificationSession({
    required String sessionId,
    required String userId,
    String? reason,
  }) async {
    try {
      final response = await _dio.post(
        '/verification/cancel',
        data: {
          'session_id': sessionId,
          'user_id': userId,
          'reason': reason ?? 'user_cancelled',
          'cancelled_at': DateTime.now().toIso8601String(),
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Error: ${e.response?.data}');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
