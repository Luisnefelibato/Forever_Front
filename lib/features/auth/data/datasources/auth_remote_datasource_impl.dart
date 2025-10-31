import 'package:forever_us_in_love/core/network/auth_api_client.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/login_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/resend_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/verify_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/auth_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/verification_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/user_model.dart';
import 'package:forever_us_in_love/features/auth/domain/datasources/auth_remote_datasource.dart' as domain;

class AuthRemoteDataSourceImpl implements domain.AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  AuthRemoteDataSourceImpl({required AuthApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      // Use Laravel native authentication
      final map = await _apiClient.login(request);

      // Token may be at top-level or inside data
      final token = (map['token'] ?? map['data']?['token'] ?? '').toString();

      // User object may be at top-level or inside data
      final userJson = (map['user'] ?? map['data']?['user']) as Map<String, dynamic>? ?? {};

      final userModel = UserModel(
        id: userJson['id']?.toString() ?? '',
        email: userJson['email'] as String?,
        phone: userJson['phone']?.toString(),
        firstName: userJson['first_name']?.toString() ?? 'User',
        lastName: userJson['last_name']?.toString() ?? 'User',
        dateOfBirth: userJson['date_of_birth']?.toString(),
        gender: userJson['gender']?.toString(),
        emailVerified: (userJson['email_verified'] as bool?) ?? false,
        phoneVerified: (userJson['phone_verified'] as bool?) ?? false,
        createdAt: (userJson['created_at']?.toString() ?? DateTime.now().toIso8601String()),
      );

      return AuthResponse(
        token: token,
        user: userModel,
        message: map['message']?.toString(),
        isNewUser: map['is_new_user'] as bool?,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final map = await _apiClient.register(request);
      // Backend returns: { success, message, data: { user: {...}, ... } }
      final userJson = (map['data']?['user'] as Map<String, dynamic>?) ?? {};
      // Build minimal UserModel and AuthResponse without token
      final userModel = UserModel(
        id: userJson['id']?.toString() ?? '',
        email: userJson['email'] as String?,
        phone: userJson['phone']?.toString(),
        firstName: userJson['first_name']?.toString() ?? 'User',
        lastName: userJson['last_name']?.toString() ?? 'User',
        dateOfBirth: userJson['date_of_birth']?.toString(),
        gender: userJson['gender']?.toString(),
        emailVerified: (userJson['email_verified'] as bool?) ?? false,
        phoneVerified: (userJson['phone_verified'] as bool?) ?? false,
        createdAt: (userJson['created_at']?.toString() ?? DateTime.now().toIso8601String()),
      );
      return AuthResponse(
        token: '',
        user: userModel,
        message: map['message']?.toString(),
        isNewUser: true,
      );
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
      Map<String, dynamic> response;
      if (request.type.toLowerCase().contains('email')) {
        response = await _apiClient.resendEmailCode();
      } else {
        response = await _apiClient.resendPhoneCode();
      }
      return VerificationResponse(
        message: response['message'] ?? 'Code sent successfully',
        verified: false,
      );
    } catch (e) {
      throw Exception('Resend code failed: $e');
    }
  }

  @override
  Future<bool> verifyRegisterOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final response = await _apiClient.verifyRegisterOtp({
        'identifier': identifier,
        'code': code,
      });
      // Consider success true when backend returns success flag
      return (response['success'] == true) || (response['verified'] == true);
    } catch (e) {
      throw Exception('Verify OTP failed: $e');
    }
  }

  @override
  Future<void> submitBasicProfile({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? interestedInGender,
    String? relationshipType,
    String? location,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
      if (gender != null) body['gender'] = gender;
      if (interestedInGender != null) body['interested_in_gender'] = interestedInGender;
      if (relationshipType != null) body['relationship_type'] = relationshipType;
      if (location != null) body['location'] = location;

      await _apiClient.submitBasicProfile(body);
    } catch (e) {
      throw Exception('Submit basic profile failed: $e');
    }
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    try {
      await _apiClient.forgotPassword({'identifier': identifier});
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  @override
  Future<void> resetPasswordWithCode({
    required String identifier,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _apiClient.resetPassword({
        'identifier': identifier,
        'reset_token': code,
        'password': newPassword,
        'password_confirmation': newPassword,
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
        'new_password_confirmation': newPassword,
      });
    } catch (e) {
      throw Exception('Change password failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkPasswordStrength(String password) async {
    try {
      return await _apiClient.checkPasswordStrength({'password': password});
    } catch (e) {
      throw Exception('Check password strength failed: $e');
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
      await _apiClient.logoutAllDevices();
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
      final response = await _apiClient.googleLogin({'token': idToken});
      return response;
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }

  @override
  Future<AuthResponse> loginWithFacebook(String idToken) async {
    try {
      final response = await _apiClient.facebookLogin({'token': idToken});
      return response;
    } catch (e) {
      throw Exception('Facebook login failed: $e');
    }
  }

  @override
  Future<AuthResponse> loginWithApple(String idToken) async {
    try {
      final response = await _apiClient.appleLogin({'id_token': idToken});
      return response;
    } catch (e) {
      throw Exception('Apple login failed: $e');
    }
  }
}
