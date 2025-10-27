import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:forever_us_in_love/core/errors/failures.dart';
import 'package:forever_us_in_love/core/errors/exceptions.dart';
import 'package:forever_us_in_love/core/storage/secure_storage_service.dart';
import 'package:forever_us_in_love/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:forever_us_in_love/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:forever_us_in_love/features/auth/domain/entities/user.dart';
import '../../../../../helpers/test_helper.dart';

// Generate mocks using mockito
@GenerateMocks([AuthRemoteDataSource, SecureStorageService])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockSecureStorageService mockStorageService;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockStorageService = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      storageService: mockStorageService,
    );
  });

  group('AuthRepositoryImpl - Login', () {
    test('should return User when login is successful', () async {
      // Arrange
      when(mockRemoteDataSource.login(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);
      when(mockStorageService.saveToken(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserId(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserEmail(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveRememberMe(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveLastLogin(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.login(
        login: TestHelper.testEmail,
        password: TestHelper.testPassword,
      );

      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) {
          expect(user.id, TestHelper.testUserId);
          expect(user.email, TestHelper.testEmail);
        },
      );
      verify(mockRemoteDataSource.login(any)).called(1);
      verify(mockStorageService.saveToken(TestHelper.testToken)).called(1);
      verify(mockStorageService.saveUserId(TestHelper.testUserId)).called(1);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(mockRemoteDataSource.login(any)).thenThrow(
        const ServerException(message: 'Invalid credentials', code: 401),
      );

      // Act
      final result = await repository.login(
        login: TestHelper.testEmail,
        password: 'wrongpassword',
      );

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Invalid credentials');
          expect((failure as ServerFailure).code, 401);
        },
        (user) => fail('Should not return user'),
      );
    });
  });

  group('AuthRepositoryImpl - Register', () {
    test('should return User when registration is successful', () async {
      // Arrange
      when(mockRemoteDataSource.register(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);
      when(mockStorageService.saveToken(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserId(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserEmail(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.register(
        email: TestHelper.testEmail,
        phone: TestHelper.testPhone,
        password: TestHelper.testPassword,
        firstName: TestHelper.testFirstName,
        lastName: TestHelper.testLastName,
        dateOfBirth: TestHelper.testDateOfBirth,
      );

      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (user) {
          expect(user.id, TestHelper.testUserId);
          expect(user.email, TestHelper.testEmail);
        },
      );
      verify(mockRemoteDataSource.register(any)).called(1);
    });

    test('should return ServerFailure when email already exists', () async {
      // Arrange
      when(mockRemoteDataSource.register(any)).thenThrow(
        const ServerException(message: 'Email already registered', code: 422),
      );

      // Act
      final result = await repository.register(
        email: TestHelper.testEmail,
        phone: TestHelper.testPhone,
        password: TestHelper.testPassword,
        firstName: TestHelper.testFirstName,
        lastName: TestHelper.testLastName,
        dateOfBirth: TestHelper.testDateOfBirth,
      );

      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Email already registered');
        },
        (user) => fail('Should not return user'),
      );
    });
  });

  group('AuthRepositoryImpl - Email Verification', () {
    test('should send email verification successfully', () async {
      // Arrange
      when(mockRemoteDataSource.sendEmailVerification())
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.sendEmailVerification();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(mockRemoteDataSource.sendEmailVerification()).called(1);
    });

    test('should verify email code successfully', () async {
      // Arrange
      when(mockRemoteDataSource.verifyEmailCode(any))
          .thenAnswer((_) async => TestHelper.mockVerificationResponse);

      // Act
      final result = await repository.verifyEmailCode(
        TestHelper.testVerificationCode,
      );

      // Assert
      expect(result, isA<Right<Failure, bool>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (verified) => expect(verified, true),
      );
      verify(mockRemoteDataSource.verifyEmailCode(any)).called(1);
    });

    test('should return failure when verification code is invalid', () async {
      // Arrange
      when(mockRemoteDataSource.verifyEmailCode(any)).thenThrow(
        const ServerException(message: 'Invalid verification code', code: 400),
      );

      // Act
      final result = await repository.verifyEmailCode('000000');

      // Assert
      expect(result, isA<Left<Failure, bool>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Invalid verification code');
        },
        (verified) => fail('Should not return verified'),
      );
    });
  });

  group('AuthRepositoryImpl - Phone Verification', () {
    test('should send phone verification successfully', () async {
      // Arrange
      when(mockRemoteDataSource.sendPhoneVerification())
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.sendPhoneVerification();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(mockRemoteDataSource.sendPhoneVerification()).called(1);
    });

    test('should verify phone code successfully', () async {
      // Arrange
      when(mockRemoteDataSource.verifyPhoneCode(any))
          .thenAnswer((_) async => TestHelper.mockVerificationResponse);

      // Act
      final result = await repository.verifyPhoneCode(
        TestHelper.testVerificationCode,
      );

      // Assert
      expect(result, isA<Right<Failure, bool>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (verified) => expect(verified, true),
      );
    });
  });

  group('AuthRepositoryImpl - Password Management', () {
    test('should send forgot password request successfully', () async {
      // Arrange
      when(mockRemoteDataSource.forgotPassword(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.forgotPassword(TestHelper.testEmail);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(mockRemoteDataSource.forgotPassword(any)).called(1);
    });

    test('should change password successfully', () async {
      // Arrange
      when(mockRemoteDataSource.changePassword(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.changePassword(
        'NewPassword456!',
        'NewPassword456!',
      );

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(mockRemoteDataSource.changePassword(any, any)).called(1);
    });
  });

  group('AuthRepositoryImpl - Logout', () {
    test('should logout successfully and clear storage', () async {
      // Arrange
      when(mockRemoteDataSource.logout()).thenAnswer((_) async => {});
      when(mockStorageService.clearAll()).thenAnswer((_) async => {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(mockRemoteDataSource.logout()).called(1);
      verify(mockStorageService.clearAll()).called(1);
    });
  });

  group('AuthRepositoryImpl - Social Auth', () {
    test('should login with Google successfully', () async {
      // Arrange
      when(mockRemoteDataSource.googleLogin(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);
      when(mockStorageService.saveToken(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserId(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserEmail(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.googleLogin('google-id-token');

      // Assert
      expect(result, isA<Right<Failure, User>>());
      verify(mockRemoteDataSource.googleLogin(any)).called(1);
    });

    test('should login with Facebook successfully', () async {
      // Arrange
      when(mockRemoteDataSource.facebookLogin(any))
          .thenAnswer((_) async => TestHelper.mockAuthResponse);
      when(mockStorageService.saveToken(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserId(any)).thenAnswer((_) async => true);
      when(mockStorageService.saveUserEmail(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.facebookLogin('facebook-id-token');

      // Assert
      expect(result, isA<Right<Failure, User>>());
      verify(mockRemoteDataSource.facebookLogin(any)).called(1);
    });
  });

  group('AuthRepositoryImpl - Auth Status', () {
    test('should check if user is authenticated', () async {
      // Arrange
      when(mockStorageService.isAuthenticated())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, true);
      verify(mockStorageService.isAuthenticated()).called(1);
    });
  });
}
