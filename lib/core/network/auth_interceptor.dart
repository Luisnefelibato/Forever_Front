import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor for handling authentication and token management
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add token to all requests if available
    final token = await _storage.getToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      
      if (kDebugMode) {
        print('🔑 Added token to request: ${options.path}');
        print('   Token: ${token.substring(0, 20)}...');
      }
    }

    if (kDebugMode) {
      print('🚀 REQUEST: ${options.method} ${options.path}');
      if (options.data != null) {
        print('📦 Body: ${options.data}');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      print('❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}');
      print('❌ Message: ${err.message}');
      if (err.response?.data != null) {
        print('❌ Response Data: ${err.response?.data}');
      }
    }

    // Handle 401 Unauthorized - Token expired or invalid
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('🔄 Token expired/invalid, attempting refresh...');
      }
      
      try {
        // Try to refresh token
        final refreshed = await _refreshToken();
        
        if (refreshed) {
          // Retry original request with new token
          final token = await _storage.getToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          // Create new Dio instance to avoid interceptor loop
          final dio = Dio(BaseOptions(
            baseUrl: 'http://3.232.35.26:8000/api/v1',
          ));
          
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Token refresh failed: $e');
        }
        
        // Clear token and redirect to login
        await _storage.clearAll();
        // TODO: Navigate to login page using navigation service
      }
    }

    handler.next(err);
  }

  /// Attempt to refresh the authentication token
  Future<bool> _refreshToken() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://3.232.35.26:8000/api/v1',
      ));

      final token = await _storage.getToken();
      
      if (token == null) {
        return false;
      }

      final response = await dio.post(
        '/auth/refresh-token',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['token'];
        
        if (newToken != null) {
          await _storage.saveToken(newToken);
          
          if (kDebugMode) {
            print('✅ Token refreshed successfully');
          }
          
          return true;
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token refresh error: $e');
      }
      return false;
    }
  }
}
