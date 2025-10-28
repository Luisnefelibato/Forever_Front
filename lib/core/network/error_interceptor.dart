import 'package:dio/dio.dart';

/// Error interceptor to handle HTTP responses and convert them to appropriate exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if response indicates an error
    if (response.statusCode != null && response.statusCode! >= 400) {
      final error = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: _getErrorMessage(response),
      );
      handler.reject(error);
      return;
    }
    
    handler.next(response);
  }

  String _getErrorMessage(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? 'Unknown error occurred';
    }
    
    switch (statusCode) {
      case 400:
        return 'Bad request - Invalid data provided';
      case 401:
        return 'Unauthorized - Authentication required';
      case 403:
        return 'Forbidden - Access denied';
      case 404:
        return 'Not found - Resource not available';
      case 422:
        return 'Validation error - Invalid input data';
      case 500:
        return 'Server error - Internal server error';
      default:
        return 'HTTP $statusCode error occurred';
    }
  }
}
