import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';

/// Creates and configures the Dio HTTP client
class ApiClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        receiveTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_AuthInterceptor());
    
    // Add logging in development mode
    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    return dio;
  }
}

/// Interceptor to add authentication token to requests
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: Get token from secure storage
    // final token = await secureStorage.read(key: 'auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    
    // Add API key if available
    if (AppConfig.apiKey.isNotEmpty) {
      options.headers['X-API-Key'] = AppConfig.apiKey;
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Handle 401 errors and refresh token if needed
    // if (err.response?.statusCode == 401) {
    //   // Refresh token logic
    // }
    
    handler.next(err);
  }
}
