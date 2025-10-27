# 🚀 Plan de Integración Backend - ForeverUsInLove

## 📋 Resumen Ejecutivo

**Backend URL**: `http://3.232.35.26:8000`  
**Base Path**: `/api/v1/auth`  
**Total Endpoints Disponibles**: 21  
**Endpoints a Implementar (Prioridad Alta)**: 13  

---

## 🎯 Objetivo

Conectar el frontend Flutter con el backend PHP Laravel para reemplazar los datos simulados con datos reales del servidor.

---

## 📊 Estado Actual vs Estado Deseado

### Estado Actual ❌
```
Usuario completa formularios → Validación local → Navegación simulada → Datos se pierden
```

### Estado Deseado ✅
```
Usuario completa formularios → BLoC Event → UseCase → Repository → API Backend
                                    ↓
                              State Update → UI Update → Datos persistentes
```

---

## 🔴 FASE 1: Setup Inicial (2-3 horas)

### 1.1 Configuración de Base

**Archivos a Crear/Modificar**:

```
lib/core/
├── network/
│   ├── api_client.dart                 ✅ Existe - MODIFICAR
│   ├── auth_api_client.dart            ❌ CREAR (Retrofit)
│   ├── dio_client.dart                 ❌ CREAR
│   └── auth_interceptor.dart           ❌ CREAR
├── storage/
│   └── secure_storage_service.dart     ❌ CREAR
└── di/
    └── injection.dart                   ⚠️ Existe - COMPLETAR
```

#### Paso 1.1.1: Actualizar configuración de API

**Archivo**: `lib/core/config/app_config.dart`

```dart
class AppConfig {
  // API Configuration - ACTUALIZAR
  static String get apiBaseUrl => 'http://3.232.35.26:8000/api/v1';
  static String get apiTimeout => '30000';
  
  // Remove unused AWS/Firebase config for now
  // We'll add them later when needed
}
```

#### Paso 1.1.2: Crear Dio Client

**Archivo**: `lib/core/network/dio_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        receiveTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Auth Interceptor
    dio.interceptors.add(AuthInterceptor());

    // Add Logger in development
    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
```

#### Paso 1.1.3: Crear Auth Interceptor

**Archivo**: `lib/core/network/auth_interceptor.dart`

```dart
import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add token to all requests if available
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print('🚀 REQUEST: ${options.method} ${options.path}');
    if (token != null) {
      print('🔑 Token: ${token.substring(0, 20)}...');
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}');
    print('❌ Message: ${err.message}');

    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      print('🔄 Token expired, attempting refresh...');
      
      try {
        // Try to refresh token
        final refreshed = await _refreshToken();
        
        if (refreshed) {
          // Retry original request with new token
          final token = await _storage.getToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        print('❌ Token refresh failed: $e');
        // Clear token and redirect to login
        await _storage.clearToken();
        // TODO: Navigate to login page
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://3.232.35.26:8000/api/v1',
      ));

      final token = await _storage.getToken();
      final response = await dio.post(
        '/auth/refresh-token',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await _storage.saveToken(newToken);
        print('✅ Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Token refresh error: $e');
      return false;
    }
  }
}
```

#### Paso 1.1.4: Crear Secure Storage Service

**Archivo**: `lib/core/storage/secure_storage_service.dart`

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Token Management
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    print('💾 Token saved to secure storage');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
    print('🗑️ Token cleared from secure storage');
  }

  // User Data Management
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
    print('🗑️ All secure data cleared');
  }
}
```

#### Paso 1.1.5: Crear Auth API Client (Retrofit)

**Archivo**: `lib/core/network/auth_api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/requests/register_request.dart';
import '../../features/auth/data/models/requests/login_request.dart';
import '../../features/auth/data/models/requests/verify_code_request.dart';
import '../../features/auth/data/models/requests/resend_code_request.dart';
import '../../features/auth/data/models/responses/auth_response.dart';
import '../../features/auth/data/models/responses/verification_response.dart';

part 'auth_api_client.g.dart';

@RestApi(baseUrl: "http://3.232.35.26:8000/api/v1")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  // REGISTRATION
  @POST("/auth/register/simple-register")
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @GET("/auth/register/check-username")
  Future<Map<String, dynamic>> checkUsername(@Query("username") String username);

  // LOGIN & LOGOUT
  @POST("/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST("/auth/logout")
  Future<void> logout();

  @POST("/auth/logout-all")
  Future<void> logoutAll();

  @POST("/auth/refresh-token")
  Future<AuthResponse> refreshToken();

  // EMAIL VERIFICATION
  @POST("/auth/verification/email/send")
  Future<void> sendEmailVerification();

  @POST("/auth/verification/email/verify")
  Future<VerificationResponse> verifyEmailCode(@Body() VerifyCodeRequest request);

  // PHONE VERIFICATION
  @POST("/auth/verification/phone/send")
  Future<void> sendPhoneVerification();

  @POST("/auth/verification/phone/verify")
  Future<VerificationResponse> verifyPhoneCode(@Body() VerifyCodeRequest request);

  // RESEND CODE
  @POST("/auth/verification/resend")
  Future<void> resendCode(@Body() ResendCodeRequest request);

  // PASSWORD MANAGEMENT
  @POST("/auth/password/forgot")
  Future<Map<String, dynamic>> forgotPassword(@Body() Map<String, dynamic> request);

  @PUT("/auth/password/change")
  Future<Map<String, dynamic>> changePassword(@Body() Map<String, dynamic> request);

  @POST("/auth/password/strength")
  Future<Map<String, dynamic>> checkPasswordStrength(@Body() Map<String, dynamic> request);

  // SOCIAL AUTH
  @POST("/auth/social/google")
  Future<AuthResponse> googleLogin(@Body() Map<String, dynamic> request);

  @POST("/auth/social/facebook")
  Future<AuthResponse> facebookLogin(@Body() Map<String, dynamic> request);
}
```

---

## 🔴 FASE 2: Modelos de Datos (2-3 horas)

### 2.1 Crear Estructura de Modelos

```
lib/features/auth/data/models/
├── requests/
│   ├── register_request.dart       ❌ CREAR
│   ├── login_request.dart          ❌ CREAR
│   ├── verify_code_request.dart    ❌ CREAR
│   └── resend_code_request.dart    ❌ CREAR
└── responses/
    ├── auth_response.dart          ❌ CREAR
    ├── verification_response.dart  ❌ CREAR
    └── user_model.dart             ❌ CREAR
```

### 2.2 Modelos de Request

#### RegisterRequest

**Archivo**: `lib/features/auth/data/models/requests/register_request.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String? email;
  final String? phone;
  final String password;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth; // Format: YYYY-MM-DD

  RegisterRequest({
    this.email,
    this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
```

#### LoginRequest

**Archivo**: `lib/features/auth/data/models/requests/login_request.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String login; // email, phone, or username
  final String password;
  final bool remember;
  @JsonKey(name: 'device_token')
  final String? deviceToken;

  LoginRequest({
    required this.login,
    required this.password,
    this.remember = true,
    this.deviceToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

#### VerifyCodeRequest

**Archivo**: `lib/features/auth/data/models/requests/verify_code_request.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String code;

  VerifyCodeRequest({required this.code});

  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
```

#### ResendCodeRequest

**Archivo**: `lib/features/auth/data/models/requests/resend_code_request.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'resend_code_request.g.dart';

@JsonSerializable()
class ResendCodeRequest {
  final String type; // 'email' or 'phone'

  ResendCodeRequest({required this.type});

  factory ResendCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResendCodeRequestToJson(this);
}
```

### 2.3 Modelos de Response

#### AuthResponse

**Archivo**: `lib/features/auth/data/models/responses/auth_response.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final UserModel user;
  final String? message;
  @JsonKey(name: 'is_new_user')
  final bool? isNewUser;

  AuthResponse({
    required this.token,
    required this.user,
    this.message,
    this.isNewUser,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
```

#### UserModel

**Archivo**: `lib/features/auth/data/models/responses/user_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String? email;
  final String? phone;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  final String? gender;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @JsonKey(name: 'created_at')
  final String createdAt;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';
}
```

#### VerificationResponse

**Archivo**: `lib/features/auth/data/models/responses/verification_response.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'verification_response.g.dart';

@JsonSerializable()
class VerificationResponse {
  final String message;
  final bool verified;
  @JsonKey(name: 'email_verified')
  final bool? emailVerified;
  @JsonKey(name: 'phone_verified')
  final bool? phoneVerified;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  VerificationResponse({
    required this.message,
    this.verified = false,
    this.emailVerified,
    this.phoneVerified,
    this.expiresAt,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationResponseToJson(this);
}
```

### 2.4 Generar Código con Build Runner

**Comando**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Este comando generará todos los archivos `.g.dart` necesarios para JSON serialization.

---

## 🔴 FASE 3: Data Sources (2 horas)

### 3.1 Crear Remote Data Source

**Archivo**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import '../../../../core/network/auth_api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/requests/register_request.dart';
import '../models/requests/login_request.dart';
import '../models/requests/verify_code_request.dart';
import '../models/requests/resend_code_request.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/verification_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<VerificationResponse> verifyEmailCode(String code);
  Future<void> resendCode(String type);
  Future<void> forgotPassword(String identifier);
  Future<void> changePassword(String newPassword, String confirmation);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.register(request);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await apiClient.login(request);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.logout();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await apiClient.sendEmailVerification();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<VerificationResponse> verifyEmailCode(String code) async {
    try {
      final request = VerifyCodeRequest(code: code);
      final response = await apiClient.verifyEmailCode(request);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> resendCode(String type) async {
    try {
      final request = ResendCodeRequest(type: type);
      await apiClient.resendCode(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    try {
      await apiClient.forgotPassword({'identifier': identifier});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> changePassword(String newPassword, String confirmation) async {
    try {
      await apiClient.changePassword({
        'new_password': newPassword,
        'new_password_confirmation': confirmation,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      
      String message = 'Server error occurred';
      
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
      }

      return ServerException(
        message: message,
        code: statusCode,
      );
    } else {
      return ServerException(
        message: 'Network error: ${error.message}',
        code: null,
      );
    }
  }
}
```

---

## 🔴 FASE 4: Repositories (1.5 horas)

### 4.1 Crear Repository Interface

**Archivo**: `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    String? email,
    String? phone,
    required String password,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
  });

  Future<Either<Failure, User>> login({
    required String login,
    required String password,
    bool remember = true,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> verifyEmailCode(String code);

  Future<Either<Failure, void>> resendVerificationCode(String type);

  Future<Either<Failure, void>> forgotPassword(String identifier);

  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String confirmation,
  );
}
```

### 4.2 Crear User Entity

**Archivo**: `lib/features/auth/domain/entities/user.dart`

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final String? gender;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        emailVerified,
        phoneVerified,
        createdAt,
      ];
}
```

### 4.3 Implementar Repository

**Archivo**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/requests/register_request.dart';
import '../models/requests/login_request.dart';

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
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );

      final response = await remoteDataSource.register(request);

      // Save token
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      if (email != null) {
        await storageService.saveUserEmail(email);
      }

      // Convert UserModel to User entity
      final user = _mapUserModelToEntity(response.user);

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
  }) async {
    try {
      final request = LoginRequest(
        login: login,
        password: password,
        remember: remember,
      );

      final response = await remoteDataSource.login(request);

      // Save token
      await storageService.saveToken(response.token);
      await storageService.saveUserId(response.user.id);
      if (response.user.email != null) {
        await storageService.saveUserEmail(response.user.email!);
      }

      final user = _mapUserModelToEntity(response.user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await storageService.clearAll();
      return const Right(null);
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
      final response = await remoteDataSource.verifyEmailCode(code);
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
      await remoteDataSource.resendCode(type);
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

  User _mapUserModelToEntity(dynamic userModel) {
    return User(
      id: userModel.id,
      email: userModel.email,
      phone: userModel.phone,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      dateOfBirth: userModel.dateOfBirth,
      gender: userModel.gender,
      emailVerified: userModel.emailVerified,
      phoneVerified: userModel.phoneVerified,
      createdAt: DateTime.parse(userModel.createdAt),
    );
  }
}
```

---

## 📝 Comandos para Ejecutar

### 1. Actualizar dependencias (si falta algo)
```bash
cd /home/user/webapp
flutter pub add dartz
flutter pub add json_annotation
flutter pub add --dev build_runner
flutter pub add --dev json_serializable
flutter pub get
```

### 2. Generar código
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Limpiar y generar de nuevo (si hay errores)
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ✅ Siguiente Paso: Implementar Login

Una vez completadas las fases 1-4, podemos proceder a:
- Crear LoginBloc
- Integrar LoginPage con el backend
- Probar el flujo completo de login

**¿Quieres que comencemos con la Fase 1?** 

Puedo crear todos estos archivos y luego probarlos con el backend real en `http://3.232.35.26:8000`.
