import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:forever_us_in_love/core/error/exceptions.dart';
import 'package:forever_us_in_love/core/network/auth_api_client.dart';
import 'package:forever_us_in_love/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../../../../helpers/test_helper.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late AuthApiClient apiClient;
  late AuthRemoteDataSourceImpl dataSource;

  const baseUrl = 'http://3.232.35.26:8000/api/v1';

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
    apiClient = AuthApiClient(dio);
    dataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  });

  group('AuthRemoteDataSource - Login Endpoints', () {
    test('POST /auth/login - should return AuthResponse on success', () async {
      // Arrange
      const path = '/auth/login';
      dioAdapter.onPost(
        path,
        (server) => server.reply(200, TestHelper.mockAuthResponseJson),
        data: TestHelper.mockLoginRequest.toJson(),
      );

      // Act
      final result = await dataSource.login(TestHelper.mockLoginRequest);

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
    });

    test('POST /auth/login - should throw ServerException on 401', () async {
      // Arrange
      const path = '/auth/login';
      dioAdapter.onPost(
        path,
        (server) => server.reply(401, TestHelper.mockErrorResponseJson),
      );

      // Act & Assert
      expect(
        () => dataSource.login(TestHelper.mockLoginRequest),
        throwsA(isA<ServerException>()),
      );
    });

    test('POST /auth/logout - should complete successfully', () async {
      // Arrange
      const path = '/auth/logout';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Logged out successfully'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.logout(),
        returnsNormally,
      );
    });

    test('POST /auth/logout/all-devices - should complete successfully',
        () async {
      // Arrange
      const path = '/auth/logout/all-devices';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Logged out from all devices'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.logoutAllDevices(),
        returnsNormally,
      );
    });

    test('POST /auth/logout/device/{deviceId} - should complete successfully',
        () async {
      // Arrange
      const deviceId = 'device-123';
      final path = '/auth/logout/device/$deviceId';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Device logged out'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.logoutDevice(deviceId),
        returnsNormally,
      );
    });

    test('GET /auth/sessions - should return list of sessions', () async {
      // Arrange
      const path = '/auth/sessions';
      dioAdapter.onGet(
        path,
        (server) => server.reply(200, {
          'data': [
            {
              'id': 'session-1',
              'device': 'iPhone 13',
              'ip': '192.168.1.1',
              'last_active': '2024-01-15T10:00:00Z',
            }
          ]
        }),
      );

      // Act
      final result = await dataSource.getSessions();

      // Assert
      expect(result, isA<List>());
      expect(result.length, 1);
    });

    test('DELETE /auth/sessions/{sessionId} - should delete session', () async {
      // Arrange
      const sessionId = 'session-123';
      final path = '/auth/sessions/$sessionId';
      dioAdapter.onDelete(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Session deleted'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.deleteSession(sessionId),
        returnsNormally,
      );
    });
  });

  group('AuthRemoteDataSource - Registration Endpoints', () {
    test('POST /auth/register/simple-register - should return AuthResponse',
        () async {
      // Arrange
      const path = '/auth/register/simple-register';
      dioAdapter.onPost(
        path,
        (server) => server.reply(201, TestHelper.mockAuthResponseJson),
      );

      // Act
      final result = await dataSource.register(TestHelper.mockRegisterRequest);

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
    });

    test(
        'POST /auth/register/with-email-verification - should return AuthResponse',
        () async {
      // Arrange
      const path = '/auth/register/with-email-verification';
      dioAdapter.onPost(
        path,
        (server) => server.reply(201, TestHelper.mockAuthResponseJson),
      );

      // Act
      final result = await dataSource.registerWithEmailVerification(
        TestHelper.mockRegisterRequest,
      );

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.emailVerified, false); // Not verified yet
    });

    test(
        'POST /auth/register/with-phone-verification - should return AuthResponse',
        () async {
      // Arrange
      const path = '/auth/register/with-phone-verification';
      dioAdapter.onPost(
        path,
        (server) => server.reply(201, TestHelper.mockAuthResponseJson),
      );

      // Act
      final result = await dataSource.registerWithPhoneVerification(
        TestHelper.mockRegisterRequest,
      );

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.phone, TestHelper.testPhone);
    });

    test('POST /auth/register - should throw ServerException on 422', () async {
      // Arrange
      const path = '/auth/register/simple-register';
      dioAdapter.onPost(
        path,
        (server) => server.reply(422, {
          'message': 'Validation failed',
          'errors': {'email': ['Email already exists']}
        }),
      );

      // Act & Assert
      expect(
        () => dataSource.register(TestHelper.mockRegisterRequest),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Email Verification Endpoints', () {
    test('POST /auth/verification/email/send - should send verification email',
        () async {
      // Arrange
      const path = '/auth/verification/email/send';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Verification email sent'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.sendEmailVerification(),
        returnsNormally,
      );
    });

    test('POST /auth/verification/email/verify - should verify email code',
        () async {
      // Arrange
      const path = '/auth/verification/email/verify';
      dioAdapter.onPost(
        path,
        (server) =>
            server.reply(200, TestHelper.mockVerificationResponseJson),
      );

      // Act
      final result = await dataSource.verifyEmailCode(
        TestHelper.mockVerifyCodeRequest,
      );

      // Assert
      expect(result.verified, true);
      expect(result.message, 'Verification successful');
    });

    test(
        'POST /auth/verification/email/verify - should throw on invalid code',
        () async {
      // Arrange
      const path = '/auth/verification/email/verify';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          400,
          TestHelper.createErrorResponse('Invalid verification code'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.verifyEmailCode(TestHelper.mockVerifyCodeRequest),
        throwsA(isA<ServerException>()),
      );
    });

    test('POST /auth/verification/email/resend - should resend verification',
        () async {
      // Arrange
      const path = '/auth/verification/email/resend';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Verification code resent'),
        ),
      );

      // Act & Assert
      expect(
        () =>
            dataSource.resendEmailVerification(TestHelper.mockResendCodeRequest),
        returnsNormally,
      );
    });

    test('GET /auth/verification/email/status - should check email status',
        () async {
      // Arrange
      const path = '/auth/verification/email/status';
      dioAdapter.onGet(
        path,
        (server) =>
            server.reply(200, TestHelper.mockVerificationResponseJson),
      );

      // Act
      final result = await dataSource.checkEmailVerificationStatus();

      // Assert
      expect(result.verified, true);
    });
  });

  group('AuthRemoteDataSource - Phone Verification Endpoints', () {
    test('POST /auth/verification/phone/send - should send verification SMS',
        () async {
      // Arrange
      const path = '/auth/verification/phone/send';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Verification SMS sent'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.sendPhoneVerification(),
        returnsNormally,
      );
    });

    test('POST /auth/verification/phone/verify - should verify phone code',
        () async {
      // Arrange
      const path = '/auth/verification/phone/verify';
      dioAdapter.onPost(
        path,
        (server) =>
            server.reply(200, TestHelper.mockVerificationResponseJson),
      );

      // Act
      final result = await dataSource.verifyPhoneCode(
        TestHelper.mockVerifyCodeRequest,
      );

      // Assert
      expect(result.verified, true);
    });

    test('POST /auth/verification/phone/resend - should resend SMS', () async {
      // Arrange
      const path = '/auth/verification/phone/resend';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('SMS code resent'),
        ),
      );

      // Act & Assert
      expect(
        () =>
            dataSource.resendPhoneVerification(TestHelper.mockResendCodeRequest),
        returnsNormally,
      );
    });
  });

  group('AuthRemoteDataSource - Password Management Endpoints', () {
    test('POST /auth/password/forgot - should send password reset email',
        () async {
      // Arrange
      const path = '/auth/password/forgot';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Password reset email sent'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.forgotPassword(TestHelper.testEmail),
        returnsNormally,
      );
    });

    test('POST /auth/password/reset - should reset password with token',
        () async {
      // Arrange
      const path = '/auth/password/reset';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Password reset successful'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.resetPassword(
          token: 'reset-token',
          password: 'NewPassword123!',
        ),
        returnsNormally,
      );
    });

    test('POST /auth/password/change - should change password', () async {
      // Arrange
      const path = '/auth/password/change';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          200,
          TestHelper.createSuccessResponse('Password changed successfully'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.changePassword(
          currentPassword: TestHelper.testPassword,
          newPassword: 'NewPassword456!',
        ),
        returnsNormally,
      );
    });

    test('POST /auth/password/forgot - should throw on invalid email',
        () async {
      // Arrange
      const path = '/auth/password/forgot';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          404,
          TestHelper.createErrorResponse('Email not found'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.forgotPassword('invalid@email.com'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Social Auth Endpoints', () {
    test('POST /auth/social/google - should login with Google', () async {
      // Arrange
      const path = '/auth/social/google';
      dioAdapter.onPost(
        path,
        (server) => server.reply(200, TestHelper.mockAuthResponseJson),
      );

      // Act
      final result = await dataSource.loginWithGoogle('google-id-token');

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
    });

    test('POST /auth/social/apple - should login with Apple', () async {
      // Arrange
      const path = '/auth/social/apple';
      dioAdapter.onPost(
        path,
        (server) => server.reply(200, TestHelper.mockAuthResponseJson),
      );

      // Act
      final result = await dataSource.loginWithApple('apple-id-token');

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
    });

    test('POST /auth/social/google - should throw on invalid token', () async {
      // Arrange
      const path = '/auth/social/google';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          401,
          TestHelper.createErrorResponse('Invalid Google token'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.loginWithGoogle('invalid-token'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Network Error Handling', () {
    test('should throw NetworkException on connection timeout', () async {
      // Arrange
      const path = '/auth/login';
      dioAdapter.onPost(
        path,
        (server) => server.throws(
          408,
          DioException.connectionTimeout(
            timeout: const Duration(seconds: 30),
            requestOptions: RequestOptions(path: path),
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.login(TestHelper.mockLoginRequest),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw ServerException on 500 internal server error',
        () async {
      // Arrange
      const path = '/auth/login';
      dioAdapter.onPost(
        path,
        (server) => server.reply(
          500,
          TestHelper.createErrorResponse('Internal server error'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.login(TestHelper.mockLoginRequest),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
