import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

/// Dio HTTP Client configuration
class DioClient {
  static Dio? _instance;

  /// Get singleton instance of Dio
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://3.232.35.26:8000/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Auth Interceptor for token management
    dio.interceptors.add(AuthInterceptor());

    // Add Logger in development mode
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }

  /// Reset instance (useful for testing)
  static void reset() {
    _instance = null;
  }
}
