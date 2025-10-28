import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/datasources/auth_remote_datasource.dart';
import '../models/requests/register_request.dart';
import '../models/requests/login_request.dart';
import '../models/requests/verify_code_request.dart';
import '../models/requests/resend_code_request.dart';

/// Implementation of auth repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, User>> register({
    String? email,
    String? phone,
    required String password,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: password, // Use same password for confirmation
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );

      final response = await remoteDataSource.register(request);

      // Save token and user data
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      
      if (email != null) {
        await storageService.saveUserEmail(email);
      }
      if (phone != null) {
        await storageService.saveUserPhone(phone);
      }

      // Convert to domain entity
      final user = response.user.toEntity();

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String login,
    required String password,
    bool remember = true,
    String? deviceToken,
  }) async {
    try {
      final request = LoginRequest(
        login: login,
        password: password,
        remember: remember,
        deviceToken: deviceToken,
      );

      final response = await remoteDataSource.login(request);

      // Save token and user data
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      
      if (response.user.email != null) {
        await storageService.saveUserEmail(response.user.email!);
      }
      if (response.user.phone != null) {
        await storageService.saveUserPhone(response.user.phone!);
      }

      // Save remember me preference
      await storageService.saveRememberMe(remember);
      if (remember) {
        await storageService.saveLastLogin(login);
      }

      final user = response.user.toEntity();

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      await storageService.clearAll();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutAll() async {
    try {
      await remoteDataSource.logoutAllDevices();
      await storageService.clearAll();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveSessions() async {
    try {
      final sessions = await remoteDataSource.getActiveSessions();
      return Right(sessions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutDevice(String deviceId) async {
    try {
      await remoteDataSource.logoutDevice(deviceId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSession(String sessionId) async {
    try {
      await remoteDataSource.deleteSession(sessionId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      final response = await remoteDataSource.refreshToken();
      
      // Update stored token
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      
      if (response.user.email != null) {
        await storageService.saveUserEmail(response.user.email!);
      }
      if (response.user.phone != null) {
        await storageService.saveUserPhone(response.user.phone!);
      }

      final user = response.user.toEntity();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmailCode(String code) async {
    try {
      final request = VerifyCodeRequest(code: code);
      final response = await remoteDataSource.verifyCode(request);
      return Right(response.verified);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPhoneVerification() async {
    try {
      await remoteDataSource.sendPhoneVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPhoneCode(String code) async {
    try {
      final request = VerifyCodeRequest(code: code);
      final response = await remoteDataSource.verifyPhoneCode(request);
      return Right(response.verified);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode(String type) async {
    try {
      final request = ResendCodeRequest(type: type);
      await remoteDataSource.resendCode(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String identifier) async {
    try {
      await remoteDataSource.forgotPassword(identifier);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String confirmation,
  ) async {
    try {
      await remoteDataSource.changePassword(newPassword, confirmation);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> googleLogin(String token) async {
    try {
      final response = await remoteDataSource.loginWithGoogle(token);

      // Save token and user data
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      
      if (response.user.email != null) {
        await storageService.saveUserEmail(response.user.email!);
      }

      final user = response.user.toEntity();

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> facebookLogin(String token) async {
    try {
      final response = await remoteDataSource.loginWithFacebook(token);

      // Save token and user data
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      
      if (response.user.email != null) {
        await storageService.saveUserEmail(response.user.email!);
      }

      final user = response.user.toEntity();

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // TODO: Implement get current user from backend
      // For now, return null
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error getting current user: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await storageService.isAuthenticated();
  }
}
