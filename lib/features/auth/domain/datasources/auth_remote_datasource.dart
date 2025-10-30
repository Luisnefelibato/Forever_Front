import 'package:forever_us_in_love/features/auth/data/models/requests/login_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/resend_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/verify_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/auth_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/verification_response.dart';

/// Abstract class defining the contract for authentication remote data source
abstract class AuthRemoteDataSource {
  // Authentication (6 endpoints for Login & Logout)
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> logout();
  Future<void> logoutAllDevices();
  Future<void> logoutDevice(String deviceId);
  Future<AuthResponse> refreshToken();
  Future<List<Map<String, dynamic>>> getActiveSessions();
  Future<void> deleteSession(String sessionId);

  // Verification
  Future<void> sendEmailVerification();
  Future<void> sendPhoneVerification();
  Future<VerificationResponse> verifyCode(VerifyCodeRequest request);
  Future<VerificationResponse> verifyPhoneCode(VerifyCodeRequest request);
  Future<VerificationResponse> resendCode(ResendCodeRequest request);

  // Registration verification & profile
  Future<bool> verifyRegisterOtp({required String identifier, required String code});
  Future<void> submitBasicProfile({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? interestedInGender,
    String? relationshipType,
    String? location,
  });

  // Password management
  Future<void> forgotPassword(String identifier);
  Future<void> resetPasswordWithCode({
    required String identifier,
    required String code,
    required String newPassword,
  });
  Future<void> changePassword(String currentPassword, String newPassword);

  // Password strength
  Future<Map<String, dynamic>> checkPasswordStrength(String password);

  // Social authentication
  Future<AuthResponse> loginWithGoogle(String idToken);
  Future<AuthResponse> loginWithFacebook(String idToken);
  Future<AuthResponse> loginWithApple(String idToken);
}
