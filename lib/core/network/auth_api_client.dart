import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/requests/register_request.dart';
import '../../features/auth/data/models/requests/login_request.dart';
import '../../features/auth/data/models/requests/verify_code_request.dart';
import '../../features/auth/data/models/requests/resend_code_request.dart';
import '../../features/auth/data/models/responses/auth_response.dart';
import '../../features/auth/data/models/responses/verification_response.dart';

part 'auth_api_client.g.dart';

/// Auth API Client using Retrofit
@RestApi(baseUrl: "http://3.232.35.26:8000/api/v1")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  // ============================================================================
  // REGISTRATION
  // ============================================================================

  @POST("/auth/register/simple-register")
  Future<Map<String, dynamic>> register(@Body() RegisterRequest request);

  /// Verify registration OTP (email or phone)
  /// Body: { "identifier": "email_or_phone", "code": "123456" }
  @POST("/auth/register/verify-otp")
  Future<Map<String, dynamic>> verifyRegisterOtp(@Body() Map<String, dynamic> request);

  /// Submit basic profile after verification
  /// Body: { first_name, last_name, date_of_birth, gender, interested_in_gender, relationship_type, location }
  @POST("/auth/register/basic-profile")
  Future<Map<String, dynamic>> submitBasicProfile(@Body() Map<String, dynamic> request);

  @GET("/auth/register/check-username")
  Future<Map<String, dynamic>> checkUsername(@Query("username") String username);

  @GET("/auth/register/suggest-usernames")
  Future<Map<String, dynamic>> suggestUsernames(
    @Query("first_name") String firstName,
    @Query("last_name") String lastName,
  );

  // ============================================================================
  // LOGIN & LOGOUT (Laravel Native - 6 endpoints)
  // ============================================================================

  /// Login with email/phone/username
  @POST("/auth/login")
  Future<Map<String, dynamic>> login(@Body() LoginRequest request);

  /// Logout current session
  @POST("/auth/logout")
  Future<void> logout();

  /// Logout all sessions on all devices
  @POST("/auth/logout/all-devices")
  Future<void> logoutAllDevices();

  /// Logout specific device
  @POST("/auth/logout/device/{device_id}")
  Future<void> logoutDevice(@Path("device_id") String deviceId);

  /// List active sessions
  @GET("/auth/sessions")
  Future<Map<String, dynamic>> getSessions();

  /// Delete specific session
  @DELETE("/auth/sessions/{session_id}")
  Future<void> deleteSession(@Path("session_id") String sessionId);

  /// Refresh expired token
  @POST("/auth/refresh-token")
  Future<AuthResponse> refreshToken();

  // ============================================================================
  // EMAIL VERIFICATION (4 endpoints)
  // ============================================================================

  /// Send email verification code
  @POST("/auth/verification/email/send")
  Future<Map<String, dynamic>> sendEmailVerification();

  /// Verify email code
  @POST("/auth/verification/email/verify")
  Future<VerificationResponse> verifyEmailCode(@Body() VerifyCodeRequest request);

  /// Resend email verification code
  @POST("/auth/verification/email/resend")
  Future<Map<String, dynamic>> resendEmailCode();

  /// Check email verification status
  @GET("/auth/verification/email/status")
  Future<Map<String, dynamic>> getEmailVerificationStatus();

  // ============================================================================
  // PHONE VERIFICATION (3 endpoints)
  // ============================================================================

  /// Send phone verification code
  @POST("/auth/verification/phone/send")
  Future<Map<String, dynamic>> sendPhoneVerification();

  /// Verify phone code
  @POST("/auth/verification/phone/verify")
  Future<VerificationResponse> verifyPhoneCode(@Body() VerifyCodeRequest request);

  /// Resend phone verification code
  @POST("/auth/verification/phone/resend")
  Future<Map<String, dynamic>> resendPhoneCode();

  // ============================================================================
  // PASSWORD MANAGEMENT (3 endpoints)
  // ============================================================================

  /// Request password reset code
  @POST("/auth/password/forgot")
  Future<Map<String, dynamic>> forgotPassword(@Body() Map<String, dynamic> request);

  /// Reset password with token/code
  @POST("/auth/password/reset")
  Future<Map<String, dynamic>> resetPassword(@Body() Map<String, dynamic> request);

  /// Change password (authenticated user)
  @PUT("/auth/password/change")
  Future<Map<String, dynamic>> changePassword(@Body() Map<String, dynamic> request);

  /// Check password strength
  @POST("/auth/password/strength")
  Future<Map<String, dynamic>> checkPasswordStrength(@Body() Map<String, dynamic> request);

  // ============================================================================
  // SOCIAL AUTH (2 endpoints)
  // ============================================================================

  /// Google OAuth login/register
  @POST("/auth/social/google")
  Future<AuthResponse> googleLogin(@Body() Map<String, dynamic> request);

  /// Apple OAuth login/register
  @POST("/auth/social/apple")
  Future<AuthResponse> appleLogin(@Body() Map<String, dynamic> request);

  /// Facebook OAuth login/register
  @POST("/auth/social/facebook")
  Future<AuthResponse> facebookLogin(@Body() Map<String, dynamic> request);

  // ============================================================================
  // IDENTITY VERIFICATION (Onfido)
  // ============================================================================

  @POST("/auth/verification/identity/workflow-run")
  Future<Map<String, dynamic>> createWorkflowRun(@Body() Map<String, dynamic> request);

  @GET("/auth/verification/identity/workflow-run/{workflowRunId}")
  Future<Map<String, dynamic>> getWorkflowRun(@Path("workflowRunId") String workflowRunId);
}
