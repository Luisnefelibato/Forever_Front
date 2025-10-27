/// Test Helper with Mock Data and Utilities
/// Provides reusable test data for auth testing
library;

import 'package:forever_us_in_love/features/auth/data/models/requests/login_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/verify_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/resend_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/auth_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/user_model.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/verification_response.dart';
import 'package:forever_us_in_love/features/auth/domain/entities/user.dart';

class TestHelper {
  // Test User Data
  static const String testUserId = 'test-user-id-123';
  static const String testEmail = 'test@example.com';
  static const String testPhone = '+1234567890';
  static const String testPassword = 'Password123!';
  static const String testFirstName = 'John';
  static const String testLastName = 'Doe';
  static const String testDateOfBirth = '1990-01-15';
  static const String testToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.token';
  static const String testRefreshToken = 'refresh.token.test';
  static const String testVerificationCode = '123456';
  static const String testDeviceToken = 'device-fcm-token-test';
  
  // Mock Requests
  static LoginRequest get mockLoginRequest => LoginRequest(
        login: testEmail,
        password: testPassword,
        remember: true,
        deviceToken: testDeviceToken,
      );

  static RegisterRequest get mockRegisterRequest => RegisterRequest(
        email: testEmail,
        phone: testPhone,
        password: testPassword,
        firstName: testFirstName,
        lastName: testLastName,
        dateOfBirth: testDateOfBirth,
      );

  static VerifyCodeRequest get mockVerifyCodeRequest => VerifyCodeRequest(
        code: testVerificationCode,
      );

  static ResendCodeRequest get mockResendCodeRequest => ResendCodeRequest(
        identifier: testEmail,
        type: 'email',
      );

  // Mock Responses
  static UserModel get mockUserModel => UserModel(
        id: testUserId,
        email: testEmail,
        phone: testPhone,
        firstName: testFirstName,
        lastName: testLastName,
        emailVerified: true,
        phoneVerified: false,
        createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
      );

  static AuthResponse get mockAuthResponse => AuthResponse(
        token: testToken,
        user: mockUserModel,
        message: 'Authentication successful',
        refreshToken: testRefreshToken,
      );

  static VerificationResponse get mockVerificationResponse =>
      VerificationResponse(
        message: 'Verification successful',
        verified: true,
      );

  // Mock Entities
  static User get mockUser => User(
        id: testUserId,
        email: testEmail,
        phone: testPhone,
        firstName: testFirstName,
        lastName: testLastName,
        emailVerified: true,
        phoneVerified: false,
        createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
      );

  // Mock JSON Responses
  static Map<String, dynamic> get mockAuthResponseJson => {
        'token': testToken,
        'refresh_token': testRefreshToken,
        'user': mockUserJson,
        'message': 'Authentication successful',
      };

  static Map<String, dynamic> get mockUserJson => {
        'id': testUserId,
        'email': testEmail,
        'phone': testPhone,
        'first_name': testFirstName,
        'last_name': testLastName,
        'email_verified': true,
        'phone_verified': false,
        'created_at': '2024-01-01T10:00:00.000000Z',
      };

  static Map<String, dynamic> get mockVerificationResponseJson => {
        'message': 'Verification successful',
        'verified': true,
      };

  static Map<String, dynamic> get mockErrorResponseJson => {
        'message': 'Invalid credentials',
        'errors': {
          'login': ['The provided credentials are incorrect.']
        },
      };

  // Helper Methods
  static Map<String, dynamic> createErrorResponse(String message) => {
        'message': message,
        'errors': {},
      };

  static Map<String, dynamic> createSuccessResponse(String message) => {
        'message': message,
      };
}
