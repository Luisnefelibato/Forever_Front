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
  Future<AuthResponse> register(@Body() RegisterRequest request);

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

  @POST("/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST("/auth/logout")
  Future<void> logout();

  @POST("/auth/logout-all")
  Future<void> logoutAll();

  @POST("/auth/logout/device/{device_id}")
  Future<void> logoutDevice(@Path("device_id") String deviceId);

  @GET("/auth/sessions")
  Future<Map<String, dynamic>> getSessions();

  @DELETE("/auth/sessions/{session_id}")
  Future<void> deleteSession(@Path("session_id") String sessionId);

  @POST("/auth/refresh-token")
  Future<AuthResponse> refreshToken();

  // ============================================================================
  // EMAIL VERIFICATION
  // ============================================================================

  @POST("/auth/verification/email/send")
  Future<void> sendEmailVerification();

  @POST("/auth/verification/email/verify")
  Future<VerificationResponse> verifyEmailCode(@Body() VerifyCodeRequest request);

  // ============================================================================
  // PHONE VERIFICATION
  // ============================================================================

  @POST("/auth/verification/phone/send")
  Future<void> sendPhoneVerification();

  @POST("/auth/verification/phone/verify")
  Future<VerificationResponse> verifyPhoneCode(@Body() VerifyCodeRequest request);

  // ============================================================================
  // RESEND CODE
  // ============================================================================

  @POST("/auth/verification/resend")
  Future<Map<String, dynamic>> resendCode(@Body() ResendCodeRequest request);

  // ============================================================================
  // PASSWORD MANAGEMENT
  // ============================================================================

  @POST("/auth/password/forgot")
  Future<Map<String, dynamic>> forgotPassword(@Body() Map<String, dynamic> request);

  @PUT("/auth/password/change")
  Future<Map<String, dynamic>> changePassword(@Body() Map<String, dynamic> request);

  @POST("/auth/password/strength")
  Future<Map<String, dynamic>> checkPasswordStrength(@Body() Map<String, dynamic> request);

  // ============================================================================
  // SOCIAL AUTH
  // ============================================================================

  @POST("/auth/social/google")
  Future<AuthResponse> googleLogin(@Body() Map<String, dynamic> request);

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
