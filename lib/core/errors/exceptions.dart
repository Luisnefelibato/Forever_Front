/// Base exception class
class AppException implements Exception {
  
  const AppException({
    required this.message,
    this.code,
  });
  final String message;
  final int? code;
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
  });
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
  });
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
  });
}
