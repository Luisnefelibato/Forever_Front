import 'package:forever_us_in_love/features/auth/data/models/requests/login_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/auth_response.dart';
import 'package:forever_us_in_love/features/auth/data/models/responses/verification_response.dart';

class TestHelper {
  // Test data constants
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testPhone = '+1234567890';
  static const String testFirstName = 'John';
  static const String testLastName = 'Doe';
  static const String testDateOfBirth = '1990-01-01';
  static const String testUserId = 'user123';
  static const String testToken = 'token123';
  static const String testRefreshToken = 'refresh123';
  static const String testVerificationCode = '123456';

  // Mock request objects
  static final LoginRequest mockLoginRequest = LoginRequest(
    login: testEmail,
    password: testPassword,
  );

  static final RegisterRequest mockRegisterRequest = RegisterRequest(
    email: testEmail,
    phone: testPhone,
    password: testPassword,
    firstName: testFirstName,
    lastName: testLastName,
    dateOfBirth: testDateOfBirth,
  );

  // Mock response objects
  static final AuthResponse mockAuthResponse = AuthResponse(
    token: testToken,
    user: UserModel(
      id: testUserId,
      email: testEmail,
      firstName: testFirstName,
      lastName: testLastName,
      phone: testPhone,
      dateOfBirth: testDateOfBirth,
      isEmailVerified: true,
      isPhoneVerified: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ),
    message: 'Login successful',
    isNewUser: false,
  );

  static final VerificationResponse mockVerificationResponse = VerificationResponse(
    message: 'Verification successful',
    verified: true,
    emailVerified: true,
    phoneVerified: false,
  );
}

// Mock UserModel class for testing
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String dateOfBirth;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.createdAt,
    required this.updatedAt,
  });
}
