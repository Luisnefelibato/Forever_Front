import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Auth repository interface - Domain layer
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, User>> register({
    String? email,
    String? phone,
    required String password,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
  });

  /// Login with email/phone/username and password
  Future<Either<Failure, User>> login({
    required String login,
    required String password,
    bool remember = true,
  });

  /// Logout current session
  Future<Either<Failure, void>> logout();

  /// Send email verification code
  Future<Either<Failure, void>> sendEmailVerification();

  /// Verify email with code
  Future<Either<Failure, bool>> verifyEmailCode(String code);

  /// Send phone verification code
  Future<Either<Failure, void>> sendPhoneVerification();

  /// Verify phone with code
  Future<Either<Failure, bool>> verifyPhoneCode(String code);

  /// Resend verification code
  Future<Either<Failure, void>> resendVerificationCode(String type);

  /// Request password reset
  Future<Either<Failure, void>> forgotPassword(String identifier);

  /// Change password
  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String confirmation,
  );

  /// Login with Google
  Future<Either<Failure, User>> googleLogin(String token);

  /// Login with Facebook
  Future<Either<Failure, User>> facebookLogin(String token);

  /// Get current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
