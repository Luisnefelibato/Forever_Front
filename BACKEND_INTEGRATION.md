# 🔗 Backend Integration Guide - Authentication Module

## 📋 Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Request/Response Examples](#requestresponse-examples)
- [Frontend Implementation](#frontend-implementation)
- [Error Handling](#error-handling)
- [Security Considerations](#security-considerations)

---

## 🎯 Overview

This document describes how the **ForeverUsInLove Frontend** authentication module integrates with the backend API to handle user registration, login, and password recovery flows.

### Registration Flow
```
Frontend (Flutter) → Backend API → Database (PostgreSQL/MySQL)
     ↓
1. User enters email/phone + password
2. Frontend validates input
3. POST /api/auth/register
4. Backend creates user record
5. Backend sends OTP via SMS/Email
6. Frontend shows OTP verification screen
7. POST /api/auth/verify-otp
8. User account activated
```

---

## 🗄️ Database Schema

### Users Table

Based on typical backend migrations, the `users` table should have the following structure:

```sql
CREATE TABLE users (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Basic Information
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    country_code VARCHAR(5),
    password_hash VARCHAR(255) NOT NULL,
    
    -- Profile Information
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    date_of_birth DATE,
    gender VARCHAR(20), -- 'Man', 'Woman', 'No Binari'
    interests VARCHAR(50), -- 'Man', 'Woman', 'Man and Woman'
    
    -- Verification Status
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    identity_verified BOOLEAN DEFAULT FALSE,
    document_verified BOOLEAN DEFAULT FALSE,
    
    -- Verification Data
    face_id_image_url VARCHAR(500),
    document_front_url VARCHAR(500),
    document_back_url VARCHAR(500),
    
    -- Account Status
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    account_status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'active', 'suspended', 'deleted'
    
    -- Authentication
    last_login_at TIMESTAMP,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP,
    
    -- OAuth
    google_id VARCHAR(255),
    facebook_id VARCHAR(255),
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    
    -- Indexes
    INDEX idx_email (email),
    INDEX idx_phone (phone_number),
    INDEX idx_created_at (created_at)
);
```

### OTP Verification Table

```sql
CREATE TABLE otp_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- OTP Details
    code VARCHAR(4) NOT NULL,
    type VARCHAR(20) NOT NULL, -- 'registration', 'password_reset', 'phone_verification'
    delivery_method VARCHAR(10) NOT NULL, -- 'sms', 'email'
    
    -- Status
    is_used BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0,
    
    -- Timestamps
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_at TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
);
```

### User Profile Images Table

```sql
CREATE TABLE user_profile_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Image Details
    image_url VARCHAR(500) NOT NULL,
    image_order INTEGER NOT NULL, -- 1-6 (1 = main image)
    is_verified BOOLEAN DEFAULT FALSE,
    
    -- S3/Storage Details
    s3_key VARCHAR(500),
    file_size_bytes INTEGER,
    mime_type VARCHAR(50),
    
    -- Timestamps
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_image_order (image_order)
);
```

### Personality Survey Table

```sql
CREATE TABLE personality_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Response Data
    question_id VARCHAR(50) NOT NULL,
    question_text TEXT,
    answer_text TEXT,
    answer_value INTEGER,
    
    -- Timestamps
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id)
);
```

---

## 🔌 API Endpoints

### 1. User Registration

#### **POST** `/api/auth/register`

**Request Body:**
```json
{
  "registrationType": "email", // or "phone"
  "email": "user@example.com", // required if registrationType = "email"
  "phoneNumber": "1234567890", // required if registrationType = "phone"
  "countryCode": "+1", // required if registrationType = "phone"
  "password": "SecurePass123",
  "confirmPassword": "SecurePass123"
}
```

**Response (Success - 201):**
```json
{
  "success": true,
  "message": "Account created successfully. Please verify your account.",
  "data": {
    "userId": "uuid-here",
    "email": "user@example.com",
    "phoneNumber": "+11234567890",
    "otpSent": true,
    "otpDeliveryMethod": "email", // or "sms"
    "otpExpiresAt": "2025-10-24T10:30:00Z"
  }
}
```

**Response (Error - 400):**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": "El correo no es válido.",
    "password": "La contraseña debe tener al menos 8 caracteres..."
  }
}
```

**Response (Error - 409):**
```json
{
  "success": false,
  "message": "El número ya se encuentra registrado"
}
```

---

### 2. Verify OTP

#### **POST** `/api/auth/verify-otp`

**Request Body:**
```json
{
  "userId": "uuid-here",
  "code": "1234",
  "type": "registration" // or "password_reset"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Account verified successfully",
  "data": {
    "userId": "uuid-here",
    "verified": true,
    "token": "jwt-token-here",
    "refreshToken": "refresh-token-here"
  }
}
```

**Response (Error - 400):**
```json
{
  "success": false,
  "message": "El código no es válido"
}
```

**Response (Error - 410):**
```json
{
  "success": false,
  "message": "El código ha expirado. Inténtalo de nuevo."
}
```

---

### 3. Resend OTP

#### **POST** `/api/auth/resend-otp`

**Request Body:**
```json
{
  "userId": "uuid-here",
  "deliveryMethod": "sms" // or "email"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Te hemos enviado un nuevo código de validación por SMS/OTP",
  "data": {
    "otpSent": true,
    "otpExpiresAt": "2025-10-24T10:30:00Z"
  }
}
```

---

### 4. Login

#### **POST** `/api/auth/login`

**Request Body:**
```json
{
  "identifier": "user@example.com", // or phone number
  "password": "SecurePass123",
  "rememberMe": true
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userId": "uuid-here",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "token": "jwt-token-here",
    "refreshToken": "refresh-token-here",
    "expiresAt": "2025-10-24T18:00:00Z"
  }
}
```

**Response (Error - 401):**
```json
{
  "success": false,
  "message": "El número de celular y/o la contraseña no son válidos"
}
```

---

### 5. Forgot Password (Step 1)

#### **POST** `/api/auth/forgot-password`

**Request Body:**
```json
{
  "identifier": "user@example.com" // or phone number
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Código de recuperación enviado",
  "data": {
    "otpSent": true,
    "deliveryMethod": "email",
    "otpExpiresAt": "2025-10-24T10:30:00Z"
  }
}
```

---

### 6. Verify Password Reset OTP

#### **POST** `/api/auth/verify-reset-code`

**Request Body:**
```json
{
  "identifier": "user@example.com",
  "code": "1234"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Código verificado correctamente",
  "data": {
    "resetToken": "temporary-reset-token-here",
    "expiresAt": "2025-10-24T10:30:00Z"
  }
}
```

---

### 7. Reset Password

#### **POST** `/api/auth/reset-password`

**Request Body:**
```json
{
  "resetToken": "temporary-reset-token-here",
  "newPassword": "NewSecurePass123",
  "confirmPassword": "NewSecurePass123"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Tu contraseña ha sido restablecida con éxito"
}
```

---

### 8. OAuth Login (Google/Facebook)

#### **POST** `/api/auth/oauth/google`

**Request Body:**
```json
{
  "idToken": "google-id-token-here",
  "accessToken": "google-access-token-here"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userId": "uuid-here",
    "email": "user@gmail.com",
    "isNewUser": false,
    "token": "jwt-token-here",
    "refreshToken": "refresh-token-here"
  }
}
```

---

## 💻 Frontend Implementation

### 1. Create Dio API Client

**File:** `lib/core/network/auth_api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi(baseUrl: "https://api.foreverusinlove.com/v1")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST("/auth/register")
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST("/auth/verify-otp")
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST("/auth/resend-otp")
  Future<ResendOtpResponse> resendOtp(@Body() ResendOtpRequest request);

  @POST("/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST("/auth/forgot-password")
  Future<ForgotPasswordResponse> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST("/auth/verify-reset-code")
  Future<VerifyResetCodeResponse> verifyResetCode(@Body() VerifyResetCodeRequest request);

  @POST("/auth/reset-password")
  Future<ResetPasswordResponse> resetPassword(@Body() ResetPasswordRequest request);

  @POST("/auth/oauth/google")
  Future<OAuthResponse> googleLogin(@Body() OAuthRequest request);

  @POST("/auth/oauth/facebook")
  Future<OAuthResponse> facebookLogin(@Body() OAuthRequest request);
}
```

### 2. Request Models

**File:** `lib/features/auth/data/models/register_request.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String registrationType; // "email" or "phone"
  final String? email;
  final String? phoneNumber;
  final String? countryCode;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.registrationType,
    this.email,
    this.phoneNumber,
    this.countryCode,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
```

### 3. Response Models

**File:** `lib/features/auth/data/models/register_response.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData? data;

  RegisterResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterData {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final bool otpSent;
  final String otpDeliveryMethod;
  final String otpExpiresAt;

  RegisterData({
    required this.userId,
    this.email,
    this.phoneNumber,
    required this.otpSent,
    required this.otpDeliveryMethod,
    required this.otpExpiresAt,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
```

### 4. Repository Implementation

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @Override
  Future<Either<Failure, User>> register({
    required String registrationType,
    String? email,
    String? phoneNumber,
    String? countryCode,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.register(
        registrationType: registrationType,
        email: email,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        password: password,
      );
      
      // Cache user data locally
      await localDataSource.cacheUser(user);
      
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'No internet connection'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @Override
  Future<Either<Failure, bool>> verifyOtp({
    required String userId,
    required String code,
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(
        userId: userId,
        code: code,
        type: type,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Verification failed'));
    }
  }

  // ... implement other methods
}
```

### 5. Use Case Example

**File:** `lib/features/auth/domain/usecases/register_user.dart`

```dart
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      registrationType: params.registrationType,
      email: params.email,
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String registrationType;
  final String? email;
  final String? phoneNumber;
  final String? countryCode;
  final String password;

  RegisterParams({
    required this.registrationType,
    this.email,
    this.phoneNumber,
    this.countryCode,
    required this.password,
  });
}
```

### 6. BLoC Implementation

**File:** `lib/features/auth/presentation/bloc/register_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/entities/user.dart';

// Events
abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String registrationType;
  final String? email;
  final String? phoneNumber;
  final String? countryCode;
  final String password;

  RegisterSubmitted({
    required this.registrationType,
    this.email,
    this.phoneNumber,
    this.countryCode,
    required this.password,
  });

  @override
  List<Object?> get props => [registrationType, email, phoneNumber, countryCode, password];
}

// States
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;
  final String userId;
  final bool otpSent;

  RegisterSuccess({
    required this.user,
    required this.userId,
    required this.otpSent,
  });

  @override
  List<Object?> get props => [user, userId, otpSent];
}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUser registerUser;

  RegisterBloc({required this.registerUser}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    final params = RegisterParams(
      registrationType: event.registrationType,
      email: event.email,
      phoneNumber: event.phoneNumber,
      countryCode: event.countryCode,
      password: event.password,
    );

    final result = await registerUser(params);

    result.fold(
      (failure) => emit(RegisterFailure(message: failure.message)),
      (user) => emit(RegisterSuccess(
        user: user,
        userId: user.id,
        otpSent: true,
      )),
    );
  }
}
```

### 7. Update Create Password Page with API Integration

**Update:** `lib/features/auth/presentation/pages/create_password_page.dart`

```dart
void _handleSubmit() async {
  if (!_canCreateAccount()) {
    return;
  }

  // Show loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // Call API using BLoC
    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        registrationType: widget.registrationType ?? 'email',
        email: widget.email,
        phoneNumber: widget.phone,
        countryCode: widget.countryCode,
        password: _passwordController.text,
      ),
    );

    // Listen for response
    // This should be handled in BlocListener wrapper
    
  } catch (e) {
    // Hide loading
    Navigator.pop(context);
    
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al crear cuenta: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

---

## 🔒 Security Considerations

### 1. Password Hashing
- **Backend**: Use `bcrypt` or `argon2` for password hashing
- **Never** send plain passwords over unencrypted connections
- Use HTTPS for all API calls

### 2. JWT Token Storage
```dart
// Store JWT securely using flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

### 3. API Key/Secret
- Store in environment variables (`.env` file)
- Never commit API keys to version control
- Use different keys for dev/staging/production

### 4. OTP Security
- OTP should expire after 10 minutes
- Limit OTP resend attempts (max 3 per 30 minutes)
- Invalidate old OTPs when new one is generated
- Rate limit OTP verification attempts

### 5. HTTPS Only
```dart
// Configure Dio to only accept HTTPS
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.foreverusinlove.com',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
));
```

---

## 🧪 Testing

### Mock API Responses

For testing without backend:

```dart
// test/mocks/mock_auth_api.dart
class MockAuthApi extends Mock implements AuthApiClient {
  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    return RegisterResponse(
      success: true,
      message: 'Account created successfully',
      data: RegisterData(
        userId: 'test-user-id',
        email: request.email,
        otpSent: true,
        otpDeliveryMethod: 'email',
        otpExpiresAt: DateTime.now().add(const Duration(minutes: 10)).toIso8601String(),
      ),
    );
  }
}
```

---

## 📝 Environment Configuration

**File:** `.env`

```env
# API Configuration
API_BASE_URL=https://api.foreverusinlove.com/v1
API_KEY=your-api-key-here
API_TIMEOUT=30000

# Environment
ENVIRONMENT=development

# AWS (for future file uploads)
AWS_REGION=us-east-1
AWS_S3_BUCKET=forever-us-in-love-uploads

# OAuth
GOOGLE_CLIENT_ID=your-google-client-id
FACEBOOK_APP_ID=your-facebook-app-id
```

---

## 🚀 Next Steps

1. **Implement API endpoints** on backend following this spec
2. **Generate code** for models: `flutter pub run build_runner build`
3. **Test each endpoint** with Postman/Insomnia
4. **Update frontend** to use real API instead of mock data
5. **Implement OTP verification** screen
6. **Add error handling** for all edge cases
7. **Set up monitoring** and logging

---

## 📞 Support

For backend API questions, contact:
- **Backend Team Lead**: [backend-lead@imagineapps.co]
- **API Documentation**: [https://api-docs.foreverusinlove.com]

---

## 👤 About You Profile Completion

### Overview

After account creation, users complete their profile through the "About You" flow:
1. **Name** (first name, last name)
2. **Birthdate** (with 18+ age validation)
3. **Gender & Interests** (upcoming)
4. **Additional profile information** (upcoming)

### Database Schema Updates

Update the `users` table with profile completion tracking:

```sql
ALTER TABLE users ADD COLUMN profile_completion_step INTEGER DEFAULT 0;
-- 0 = Account created, not started
-- 1 = Name completed
-- 2 = Birthdate completed
-- 3 = Gender/Interests completed
-- 4 = Profile complete

ALTER TABLE users ADD COLUMN profile_completed_at TIMESTAMP NULL;
```

### API Endpoint: Update User Profile

**Endpoint:** `POST /api/users/profile/update`

**Purpose:** Update user profile information during "About You" flow

**Headers:**
```json
{
  "Authorization": "Bearer <access_token>",
  "Content-Type": "application/json"
}
```

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "dateOfBirth": "1990-06-04",
  "completionStep": 2
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "firstName": "John",
    "lastName": "Doe",
    "dateOfBirth": "1990-06-04",
    "age": 34,
    "profileCompletionStep": 2,
    "profileCompletionPercentage": 40
  }
}
```

**Error Responses:**

**400 Bad Request** - Invalid data:
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "dateOfBirth",
      "message": "User must be at least 18 years old"
    }
  ]
}
```

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Authentication required",
  "errorCode": "UNAUTHORIZED"
}
```

**422 Unprocessable Entity:**
```json
{
  "success": false,
  "message": "Invalid date of birth format",
  "errorCode": "INVALID_DATE_FORMAT"
}
```

### Validation Rules

**Backend must validate:**

1. **First Name:**
   - Required
   - Minimum 1 character
   - Maximum 25 characters
   - Only alphabetic characters and spaces

2. **Last Name:**
   - Required
   - Minimum 1 character
   - Maximum 25 characters
   - Only alphabetic characters and spaces

3. **Date of Birth:**
   - Required
   - Valid date format (YYYY-MM-DD)
   - User must be 18 years or older
   - Date cannot be in the future
   - Date must be a realistic age (not more than 120 years ago)

### Backend Implementation Example (Node.js/Express)

```javascript
// routes/users.js
router.post('/profile/update', authenticateToken, async (req, res) => {
  try {
    const { firstName, lastName, dateOfBirth, completionStep } = req.body;
    const userId = req.user.id; // From JWT token

    // Validate age (18+)
    if (dateOfBirth) {
      const birthDate = new Date(dateOfBirth);
      const age = calculateAge(birthDate);
      
      if (age < 18) {
        return res.status(400).json({
          success: false,
          message: 'User must be at least 18 years old',
          errorCode: 'AGE_RESTRICTION'
        });
      }
    }

    // Update user profile
    const updatedUser = await User.update(
      {
        first_name: firstName,
        last_name: lastName,
        date_of_birth: dateOfBirth,
        profile_completion_step: completionStep,
        updated_at: new Date()
      },
      {
        where: { id: userId }
      }
    );

    // Calculate profile completion percentage
    const completionPercentage = (completionStep / 5) * 100;

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: {
        userId,
        firstName,
        lastName,
        dateOfBirth,
        age: calculateAge(new Date(dateOfBirth)),
        profileCompletionStep: completionStep,
        profileCompletionPercentage: completionPercentage
      }
    });

  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while updating profile',
      errorCode: 'SERVER_ERROR'
    });
  }
});

function calculateAge(birthDate) {
  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  
  return age;
}
```

### Frontend Implementation

**Service Method:**

```dart
// lib/features/profile/data/datasources/profile_remote_datasource.dart

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @POST('/users/profile/update')
  Future<ProfileUpdateResponse> updateProfile(
    @Body() ProfileUpdateRequest request,
  );
}

// Request model
class ProfileUpdateRequest {
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth; // YYYY-MM-DD format
  final int completionStep;

  ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    required this.completionStep,
  });

  Map<String, dynamic> toJson() => {
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    'completionStep': completionStep,
  };
}
```

**Usage in AboutYouBirthdatePage:**

```dart
void _validateAndContinue() async {
  // ... validation code ...

  try {
    // Format date as YYYY-MM-DD
    final dateOfBirth = '${_selectedYear!}-${_selectedMonth!.toString().padLeft(2, '0')}-${_selectedDay!.toString().padLeft(2, '0')}';

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Call API
    final response = await profileApiClient.updateProfile(
      ProfileUpdateRequest(
        firstName: widget.firstName,
        lastName: widget.lastName,
        dateOfBirth: dateOfBirth,
        completionStep: 2,
      ),
    );

    // Hide loading
    Navigator.pop(context);

    // Navigate to next screen
    Navigator.pushNamed(context, '/about-you-gender');

  } catch (e) {
    // Handle error
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### Migration Script

```sql
-- Add profile completion tracking
ALTER TABLE users 
  ADD COLUMN profile_completion_step INTEGER DEFAULT 0,
  ADD COLUMN profile_completed_at TIMESTAMP NULL;

-- Add index for faster queries
CREATE INDEX idx_profile_completion ON users(profile_completion_step);

-- Update existing users
UPDATE users 
SET profile_completion_step = 0 
WHERE profile_completion_step IS NULL;
```

---

**Document Version**: 1.1  
**Last Updated**: 2025-10-24  
**Author**: GenSpark AI Developer
