import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/token_refresh_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

/// Authentication Service
/// 
/// Handles login, logout, and session management
class AuthService {
  final AuthRepository _authRepository;
  final TokenRefreshService _tokenRefreshService;
  
  AuthService({
    required AuthRepository authRepository,
    required TokenRefreshService tokenRefreshService,
  })  : _authRepository = authRepository,
        _tokenRefreshService = tokenRefreshService;

  /// Login with email/phone/username
  Future<Either<Failure, User>> login({
    required String login,
    required String password,
    bool remember = true,
    String? deviceToken,
  }) async {
    try {
      return await _authRepository.login(
        login: login,
        password: password,
        remember: remember,
        deviceToken: deviceToken,
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed: $e'));
    }
  }

  /// Logout current session
  Future<Either<Failure, bool>> logout() async {
    try {
      // Stop token refresh service
      stopTokenRefresh();
      
      final result = await _authRepository.logout();
      return result;
    } catch (e) {
      return Left(ServerFailure(message: 'Logout failed: $e'));
    }
  }

  /// Logout all sessions
  Future<Either<Failure, bool>> logoutAll() async {
    try {
      // Stop token refresh service
      stopTokenRefresh();
      
      final result = await _authRepository.logoutAll();
      return result;
    } catch (e) {
      return Left(ServerFailure(message: 'Logout all failed: $e'));
    }
  }

  /// Logout specific device
  Future<Either<Failure, bool>> logoutDevice(String deviceId) async {
    try {
      final result = await _authRepository.logoutDevice(deviceId);
      
      // If this is the current device, stop token refresh
      // Note: You might want to check if the logged out device is the current one
      stopTokenRefresh();
      
      return result;
    } catch (e) {
      return Left(ServerFailure(message: 'Logout device failed: $e'));
    }
  }

  /// Get active sessions
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveSessions() async {
    try {
      return await _authRepository.getActiveSessions();
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get sessions: $e'));
    }
  }

  /// Delete specific session
  Future<Either<Failure, bool>> deleteSession(String sessionId) async {
    try {
      return await _authRepository.deleteSession(sessionId);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete session: $e'));
    }
  }

  /// Refresh authentication token
  Future<Either<Failure, User>> refreshToken() async {
    try {
      return await _authRepository.refreshToken();
    } catch (e) {
      return Left(ServerFailure(message: 'Token refresh failed: $e'));
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final result = await _authRepository.getCurrentUser();
      return result.fold(
        (failure) => false,
        (user) => user != null,
      );
    } catch (e) {
      return false;
    }
  }

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      return await _authRepository.getCurrentUser();
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get current user: $e'));
    }
  }

  /// Refresh token manually
  Future<bool> refreshTokenManually() async {
    try {
      return await _tokenRefreshService.refreshToken();
    } catch (e) {
      return false;
    }
  }

  /// Force refresh token
  Future<bool> forceRefreshToken() async {
    try {
      return await _tokenRefreshService.forceRefresh();
    } catch (e) {
      return false;
    }
  }

  /// Check if token needs refresh
  Future<bool> needsTokenRefresh() async {
    try {
      return await _tokenRefreshService.needsRefresh();
    } catch (e) {
      return false;
    }
  }

  /// Stop token refresh service (useful for logout)
  void stopTokenRefresh() {
    _tokenRefreshService.stop();
  }
}
