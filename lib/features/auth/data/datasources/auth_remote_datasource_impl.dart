import 'package:forever_us_in_love/core/network/auth_api_client.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/login_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/resend_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/verify_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/auth_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/verification_response.dart';
import 'package:forever_us_in_love/features/auth/domain/datasources/auth_remote_datasource.dart' as domain;

class AuthRemoteDataSourceImpl implements domain.AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  AuthRemoteDataSourceImpl({required AuthApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      // Use Laravel native authentication
      final response = await _apiClient.login(request);
      
      // Check if response is successful
      if (response is! AuthResponse) {
        throw Exception('Invalid response format');
      }
      
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request);
      
      // Check if response is successful
      if (response is! AuthResponse) {
        throw Exception('Invalid response format');
      }
      
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _apiClient.sendEmailVerification();
    } catch (e) {
      throw Exception('Send email verification failed: $e');
    }
  }

  @override
  Future<void> sendPhoneVerification() async {
    try {
      await _apiClient.sendPhoneVerification();
    } catch (e) {
      throw Exception('Send phone verification failed: $e');
    }
  }

  @override
  Future<VerificationResponse> verifyCode(VerifyCodeRequest request) async {
    try {
      // Try email verification first
      final response = await _apiClient.verifyEmailCode(request);
      return response;
    } catch (e) {
      throw Exception('Code verification failed: $e');
    }
  }

  @override
  Future<VerificationResponse> verifyPhoneCode(VerifyCodeRequest request) async {
    try {
      final response = await _apiClient.verifyPhoneCode(request);
      return response;
    } catch (e) {
      throw Exception('Phone code verification failed: $e');
    }
  }

  @override
  Future<VerificationResponse> resendCode(ResendCodeRequest request) async {
    try {
      final response = await _apiClient.resendCode(request);
      return VerificationResponse(
        message: response['message'] ?? 'Code sent successfully',
        verified: false,
      );
    } catch (e) {
      throw Exception('Resend code failed: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.forgotPassword({'email': email});
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      await _apiClient.changePassword({
        'email': email,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _apiClient.changePassword({
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Change password failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> logoutAllDevices() async {
    try {
      await _apiClient.logoutAll();
    } catch (e) {
      throw Exception('Logout all devices failed: $e');
    }
  }

  @override
  Future<AuthResponse> refreshToken() async {
    try {
      final response = await _apiClient.refreshToken();
      
      // Check if response is successful
      if (response is! AuthResponse) {
        throw Exception('Invalid response format');
      }
      
      return response;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveSessions() async {
    try {
      final response = await _apiClient.getSessions();
      
      // Extract sessions from response
      if (response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get active sessions: $e');
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    try {
      await _apiClient.deleteSession(sessionId);
    } catch (e) {
      throw Exception('Failed to delete session: $e');
    }
  }

  @override
  Future<void> logoutDevice(String deviceId) async {
    try {
      await _apiClient.logoutDevice(deviceId);
    } catch (e) {
      throw Exception('Failed to logout device: $e');
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiClient.googleLogin({'id_token': idToken});
      return response;
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }

  @override
  Future<AuthResponse> loginWithFacebook(String idToken) async {
    try {
      final response = await _apiClient.facebookLogin({'id_token': idToken});
      return response;
    } catch (e) {
      throw Exception('Facebook login failed: $e');
    }
  }

  @override
  Future<AuthResponse> loginWithApple(String idToken) async {
    try {
      final response = await _apiClient.facebookLogin({'id_token': idToken});
      return response;
    } catch (e) {
      throw Exception('Apple login failed: $e');
    }
  }
}
