import 'package:dio/dio.dart';
import '../../../../core/network/auth_api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/requests/register_request.dart';
import '../models/requests/login_request.dart';
import '../models/requests/verify_code_request.dart';
import '../models/requests/resend_code_request.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/verification_response.dart';

/// Abstract class for auth remote data source
abstract class AuthRemoteDataSource {
  // Registration
  Future<AuthResponse> register(RegisterRequest request);
  
  // Login & Logout
  Future<AuthResponse> login(LoginRequest request);
  Future<void> logout();
  Future<AuthResponse> refreshToken();
  
  // Email Verification
  Future<void> sendEmailVerification();
  Future<VerificationResponse> verifyEmailCode(String code);
  
  // Phone Verification
  Future<void> sendPhoneVerification();
  Future<VerificationResponse> verifyPhoneCode(String code);
  
  // Resend Code
  Future<void> resendCode(String type);
  
  // Password Management
  Future<void> forgotPassword(String identifier);
  Future<void> changePassword(String newPassword, String confirmation);
  
  // Social Auth
  Future<AuthResponse> googleLogin(String token);
  Future<AuthResponse> facebookLogin(String token);
}

/// Implementation of auth remote data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      return await apiClient.register(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      return await apiClient.login(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.logout();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> refreshToken() async {
    try {
      return await apiClient.refreshToken();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await apiClient.sendEmailVerification();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<VerificationResponse> verifyEmailCode(String code) async {
    try {
      final request = VerifyCodeRequest(code: code);
      return await apiClient.verifyEmailCode(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> sendPhoneVerification() async {
    try {
      await apiClient.sendPhoneVerification();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<VerificationResponse> verifyPhoneCode(String code) async {
    try {
      final request = VerifyCodeRequest(code: code);
      return await apiClient.verifyPhoneCode(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> resendCode(String type) async {
    try {
      final request = ResendCodeRequest(type: type);
      await apiClient.resendCode(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    try {
      await apiClient.forgotPassword({'identifier': identifier});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> changePassword(String newPassword, String confirmation) async {
    try {
      await apiClient.changePassword({
        'new_password': newPassword,
        'new_password_confirmation': confirmation,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> googleLogin(String token) async {
    try {
      return await apiClient.googleLogin({'token': token});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> facebookLogin(String token) async {
    try {
      return await apiClient.facebookLogin({'token': token});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to ServerException
  ServerException _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      
      String message = 'Server error occurred';
      
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
        
        // Handle validation errors
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final errorMessages = errors.values.join(', ');
          message = errorMessages.isNotEmpty ? errorMessages : message;
        }
      }

      return ServerException(
        message: message,
        code: statusCode,
      );
    } else {
      // Network error
      return ServerException(
        message: 'Network error: ${error.message}',
        code: null,
      );
    }
  }
}
