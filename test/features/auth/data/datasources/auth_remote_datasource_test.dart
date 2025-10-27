import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:forever_us_in_love/core/errors/exceptions.dart';
import 'package:forever_us_in_love/core/network/auth_api_client.dart';
import 'package:forever_us_in_love/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../../../../helpers/test_helper.dart';

// Generate mocks
@GenerateMocks([AuthApiClient])
import 'auth_remote_datasource_test_simplified.mocks.dart';

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('AuthRemoteDataSource - Login', () {
    test('should return AuthResponse when login succeeds', () async {
      // Arrange
      when(mockApiClient.login(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);

      // Act
      final result = await dataSource.login(TestHelper.mockLoginRequest);

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
      verify(mockApiClient.login(any)).called(1);
    });

    test('should throw ServerException when login fails with 401', () async {
      // Arrange
      when(mockApiClient.login(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.login(TestHelper.mockLoginRequest),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Register', () {
    test('should return AuthResponse when registration succeeds', () async {
      // Arrange
      when(mockApiClient.register(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);

      // Act
      final result = await dataSource.register(TestHelper.mockRegisterRequest);

      // Assert
      expect(result.token, TestHelper.testToken);
      expect(result.user.email, TestHelper.testEmail);
      verify(mockApiClient.register(any)).called(1);
    });

    test('should throw ServerException when email already exists', () async {
      // Arrange
      when(mockApiClient.register(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/register'),
            statusCode: 422,
            data: {
              'message': 'Validation failed',
              'errors': {'email': ['Email already exists']}
            },
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.register(TestHelper.mockRegisterRequest),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Email Verification', () {
    test('should send email verification successfully', () async {
      // Arrange
      when(mockApiClient.sendEmailVerification())
          .thenAnswer((_) async => {});

      // Act & Assert
      await dataSource.sendEmailVerification();
      verify(mockApiClient.sendEmailVerification()).called(1);
    });

    test('should verify email code successfully', () async {
      // Arrange
      when(mockApiClient.verifyEmailCode(any))
          .thenAnswer((_) async => TestHelper.mockVerificationResponse);

      // Act
      final result = await dataSource.verifyEmailCode('123456');

      // Assert
      expect(result.verified, true);
      verify(mockApiClient.verifyEmailCode(any)).called(1);
    });

    test('should throw ServerException when verification code is invalid', () async {
      // Arrange
      when(mockApiClient.verifyEmailCode(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/verification/email/verify'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/verification/email/verify'),
            statusCode: 400,
            data: {'message': 'Invalid verification code'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.verifyEmailCode('000000'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Phone Verification', () {
    test('should send phone verification successfully', () async {
      // Arrange
      when(mockApiClient.sendPhoneVerification())
          .thenAnswer((_) async => {});

      // Act & Assert
      await dataSource.sendPhoneVerification();
      verify(mockApiClient.sendPhoneVerification()).called(1);
    });

    test('should verify phone code successfully', () async {
      // Arrange
      when(mockApiClient.verifyPhoneCode(any))
          .thenAnswer((_) async => TestHelper.mockVerificationResponse);

      // Act
      final result = await dataSource.verifyPhoneCode('123456');

      // Assert
      expect(result.verified, true);
      verify(mockApiClient.verifyPhoneCode(any)).called(1);
    });
  });

  group('AuthRemoteDataSource - Password Management', () {
    test('should send forgot password request successfully', () async {
      // Arrange
      when(mockApiClient.forgotPassword(any))
          .thenAnswer((_) async => {'message': 'Reset email sent'});

      // Act & Assert
      await dataSource.forgotPassword('test@example.com');
      verify(mockApiClient.forgotPassword(any)).called(1);
    });

    test('should change password successfully', () async {
      // Arrange
      when(mockApiClient.changePassword(any))
          .thenAnswer((_) async => {'message': 'Password changed'});

      // Act & Assert
      await dataSource.changePassword('newpass123', 'newpass123');
      verify(mockApiClient.changePassword(any)).called(1);
    });

    test('should throw ServerException when email not found', () async {
      // Arrange
      when(mockApiClient.forgotPassword(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/password/forgot'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/password/forgot'),
            statusCode: 404,
            data: {'message': 'Email not found'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.forgotPassword('notfound@example.com'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Social Auth', () {
    test('should login with Google successfully', () async {
      // Arrange
      when(mockApiClient.googleLogin(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);

      // Act
      final result = await dataSource.googleLogin('google-token');

      // Assert
      expect(result.token, TestHelper.testToken);
      verify(mockApiClient.googleLogin(any)).called(1);
    });

    test('should login with Facebook successfully', () async {
      // Arrange
      when(mockApiClient.facebookLogin(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);

      // Act
      final result = await dataSource.facebookLogin('facebook-token');

      // Assert
      expect(result.token, TestHelper.testToken);
      verify(mockApiClient.facebookLogin(any)).called(1);
    });

    test('should throw ServerException when Google token is invalid', () async {
      // Arrange
      when(mockApiClient.googleLogin(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/social/google'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/social/google'),
            statusCode: 401,
            data: {'message': 'Invalid Google token'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.googleLogin('invalid-token'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDataSource - Logout', () {
    test('should logout successfully', () async {
      // Arrange
      when(mockApiClient.logout())
          .thenAnswer((_) async => {});

      // Act & Assert
      await dataSource.logout();
      verify(mockApiClient.logout()).called(1);
    });
  });

  group('AuthRemoteDataSource - Error Handling', () {
    test('should handle network timeout', () async {
      // Arrange
      when(mockApiClient.login(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.login(TestHelper.mockLoginRequest),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle server error 500', () async {
      // Arrange
      when(mockApiClient.login(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
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
