# 🔗 Backend API Integration Mapping

## 📊 Base URL Configuration

```
Production: http://3.232.35.26:8000/
Base Path: /api/v1/auth/
```

---

## 📋 Complete Endpoint List

### 🔐 **1. LOGIN & LOGOUT (6 endpoints)**

#### 1.1 Login
- **Endpoint**: `POST /api/v1/auth/login`
- **Frontend Page**: `login_page.dart`
- **Request Body**:
```json
{
  "login": "user@example.com",  // email, username, or phone
  "password": "Password123!@#",
  "remember": true,
  "device_token": "optional_device_token"
}
```
- **Response**: 
```json
{
  "token": "jwt_token_here",
  "user": { ... }
}
```
- **Current Implementation**: ❌ Mock validation only
- **Action Required**: ✅ Integrate with BLoC

---

#### 1.2 Logout
- **Endpoint**: `POST /api/v1/auth/logout`
- **Frontend Page**: All authenticated pages (header/drawer)
- **Headers**: `Authorization: Bearer {{token}}`
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ✅ Add to user menu/settings

---

#### 1.3 Logout All
- **Endpoint**: `POST /api/v1/auth/logout-all`
- **Frontend Page**: Settings/Security page (future)
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Close all sessions on all devices
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ⏳ Future feature

---

#### 1.4 Refresh Token
- **Endpoint**: `POST /api/v1/auth/refresh-token`
- **Frontend**: Dio Interceptor (automatic)
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Refresh expired token automatically
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ✅ Implement in auth interceptor

---

#### 1.5 Sessions List
- **Endpoint**: `GET /api/v1/auth/sessions`
- **Frontend Page**: Settings/Active Sessions (future)
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: List all active sessions
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ⏳ Future feature

---

#### 1.6 Terminate Session
- **Endpoint**: `DELETE /api/v1/auth/sessions/:tokenId`
- **Frontend Page**: Settings/Active Sessions (future)
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Close specific session
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ⏳ Future feature

---

### 📝 **2. REGISTRATION (3 endpoints)**

#### 2.1 Simple Register
- **Endpoint**: `POST /api/v1/auth/register/simple-register`
- **Frontend Page**: `create_password_page.dart`
- **Request Body**:
```json
{
  "email": "user@example.com",
  "password": "Password123!@#",
  "first_name": "John",
  "last_name": "Doe",
  "date_of_birth": "1990-01-15"
}
```
- **Response**:
```json
{
  "message": "User registered successfully",
  "user": { ... },
  "token": "jwt_token_here"
}
```
- **Current Implementation**: ❌ Shows mock success page
- **Action Required**: ✅ HIGH PRIORITY - Integrate after password creation
- **Note**: Should collect data from About You flow first

---

#### 2.2 Check Username
- **Endpoint**: `GET /api/v1/auth/register/check-username?username=testuser`
- **Frontend Page**: About You / Username page (not implemented)
- **Query Params**: `username` (string)
- **Response**:
```json
{
  "available": true,
  "message": "Username is available"
}
```
- **Current Implementation**: ❌ Username feature not in UI
- **Action Required**: ⏳ Future - if username feature is added

---

#### 2.3 Suggest Usernames
- **Endpoint**: `GET /api/v1/auth/register/suggest-usernames?first_name=John&last_name=Doe`
- **Frontend Page**: About You / Username page (not implemented)
- **Query Params**: 
  - `first_name` (string)
  - `last_name` (string)
- **Response**:
```json
{
  "suggestions": ["john_doe", "john.doe123", "johndoe90"]
}
```
- **Current Implementation**: ❌ Username feature not in UI
- **Action Required**: ⏳ Future - if username feature is added

---

### ✅ **3. VERIFICATION (7 endpoints)**

#### 3.1 Send Email Verification
- **Endpoint**: `POST /api/v1/auth/verification/email/send`
- **Frontend Page**: After registration / Email verification screen
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Sends 6-digit code to user's email
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ✅ HIGH PRIORITY - OTP flow
- **Note**: Should be called automatically after registration

---

#### 3.2 Verify Email Code
- **Endpoint**: `POST /api/v1/auth/verification/email/verify`
- **Frontend Page**: OTP verification screen (to be created)
- **Headers**: `Authorization: Bearer {{token}}`
- **Request Body**:
```json
{
  "code": "123456"
}
```
- **Response**:
```json
{
  "message": "Email verified successfully",
  "email_verified": true
}
```
- **Current Implementation**: ❌ UI exists but not connected
- **Action Required**: ✅ HIGH PRIORITY - Create OTP page

---

#### 3.3 Send Phone Verification
- **Endpoint**: `POST /api/v1/auth/verification/phone/send`
- **Frontend Page**: After registration / Phone verification screen
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Sends SMS code to user's phone
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ✅ MEDIUM PRIORITY - For phone registrations

---

#### 3.4 Verify Phone Code
- **Endpoint**: `POST /api/v1/auth/verification/phone/verify`
- **Frontend Page**: OTP verification screen (to be created)
- **Headers**: `Authorization: Bearer {{token}}`
- **Request Body**:
```json
{
  "code": "123456"
}
```
- **Response**:
```json
{
  "message": "Phone verified successfully",
  "phone_verified": true
}
```
- **Current Implementation**: ❌ UI exists but not connected
- **Action Required**: ✅ MEDIUM PRIORITY - For phone registrations

---

#### 3.5 Create Identity Workflow Run (Onfido)
- **Endpoint**: `POST /api/v1/auth/verification/identity/workflow-run`
- **Frontend Page**: `verification_prompt_page.dart` (Face ID/Document verification)
- **Headers**: `Authorization: Bearer {{token}}`
- **Request Body**:
```json
{
  "workflow_id": "your_workflow_id",
  "custom_data": {}
}
```
- **Response**:
```json
{
  "workflow_run_id": "uuid",
  "sdk_token": "onfido_sdk_token"
}
```
- **Current Implementation**: ❌ Shows skip prompt only
- **Action Required**: ✅ MEDIUM PRIORITY - Identity verification
- **Note**: Requires Onfido SDK integration

---

#### 3.6 Get Workflow Run Status (Onfido)
- **Endpoint**: `GET /api/v1/auth/verification/identity/workflow-run/:workflowRunId`
- **Frontend Page**: Identity verification status page
- **Headers**: `Authorization: Bearer {{token}}`
- **Description**: Check identity verification status
- **Current Implementation**: ❌ Not implemented
- **Action Required**: ✅ MEDIUM PRIORITY - After workflow creation

---

#### 3.7 Resend Code
- **Endpoint**: `POST /api/v1/auth/verification/resend`
- **Frontend Page**: OTP verification screens
- **Headers**: `Authorization: Bearer {{token}}`
- **Request Body**:
```json
{
  "type": "email"  // or "phone"
}
```
- **Response**:
```json
{
  "message": "Code resent successfully",
  "expires_at": "2025-10-27T..."
}
```
- **Current Implementation**: ❌ Timer exists but doesn't call API
- **Action Required**: ✅ HIGH PRIORITY - OTP resend button

---

### 🔑 **4. PASSWORD MANAGEMENT (3 endpoints)**

#### 4.1 Forgot Password
- **Endpoint**: `POST /api/v1/auth/password/forgot`
- **Frontend Page**: `forgot_password_email_page.dart`
- **Request Body**:
```json
{
  "identifier": "user@example.com"  // email or phone
}
```
- **Response**:
```json
{
  "message": "Recovery code sent",
  "delivery_method": "email",
  "expires_at": "..."
}
```
- **Current Implementation**: ❌ UI exists, not connected
- **Action Required**: ✅ HIGH PRIORITY - Password recovery flow
- **Next Step**: Should navigate to `forgot_password_code_page.dart`

---

#### 4.2 Change Password
- **Endpoint**: `PUT /api/v1/auth/password/change`
- **Frontend Page**: `reset_password_page.dart` + Settings (future)
- **Headers**: `Authorization: Bearer {{token}}`
- **Request Body**:
```json
{
  "current_password": "OldPassword123!",
  "new_password": "NewPassword123!",
  "new_password_confirmation": "NewPassword123!"
}
```
- **Response**:
```json
{
  "message": "Password changed successfully"
}
```
- **Current Implementation**: ❌ UI exists but not connected
- **Action Required**: ✅ HIGH PRIORITY - Complete forgot password flow
- **Note**: Need to verify OTP first, then change password

---

#### 4.3 Check Password Strength
- **Endpoint**: `POST /api/v1/auth/password/strength`
- **Frontend Page**: `create_password_page.dart`, `reset_password_page.dart`
- **Request Body**:
```json
{
  "password": "Password123!@#"
}
```
- **Response**:
```json
{
  "strength": "strong",
  "score": 8,
  "feedback": ["Good mix of characters"]
}
```
- **Current Implementation**: ⚠️ Local validation only
- **Action Required**: ⏳ OPTIONAL - Could enhance with backend validation

---

### 🔗 **5. SOCIAL AUTH (2 endpoints)**

#### 5.1 Google Login
- **Endpoint**: `POST /api/v1/auth/social/google`
- **Frontend Page**: `login_page.dart`, `welcome_page.dart`
- **Request Body**:
```json
{
  "token": "google_id_token"
}
```
- **Response**:
```json
{
  "token": "jwt_token",
  "user": { ... },
  "is_new_user": false
}
```
- **Current Implementation**: ❌ Button exists but not functional
- **Action Required**: ✅ MEDIUM PRIORITY - OAuth integration
- **Dependencies**: 
  - Google Sign-In Flutter package ✅ Installed
  - Firebase configuration needed

---

#### 5.2 Facebook Login
- **Endpoint**: `POST /api/v1/auth/social/facebook`
- **Frontend Page**: `login_page.dart`, `welcome_page.dart`
- **Request Body**:
```json
{
  "token": "facebook_access_token"
}
```
- **Response**:
```json
{
  "token": "jwt_token",
  "user": { ... },
  "is_new_user": false
}
```
- **Current Implementation**: ❌ Not implemented (no package)
- **Action Required**: ✅ MEDIUM PRIORITY - OAuth integration
- **Dependencies**:
  - Facebook Login package ❌ Not installed
  - Facebook App configuration needed

---

## 🗺️ Frontend to Backend Mapping

### Registration Flow

```
┌─────────────────────────────────────────────────────────────┐
│ REGISTRATION FLOW - Frontend to Backend Integration        │
└─────────────────────────────────────────────────────────────┘

1. WelcomePage
   └─> Choose Email or Phone registration

2. RegisterEmailPage / RegisterPhonePage
   └─> Collect: email/phone
   └─> Navigate to CreatePasswordPage
   
3. CreatePasswordPage
   └─> Collect: password, confirm_password
   └─> Navigate to AboutYouNamePage
   
4. AboutYouNamePage
   └─> Collect: first_name, last_name
   └─> Navigate to AboutYouBirthdatePage
   
5. AboutYouBirthdatePage
   └─> Collect: date_of_birth
   └─> Navigate to AboutYouGenderPage
   
6. AboutYouGenderPage
   └─> Collect: gender
   └─> Navigate to AboutYouInterestsPage
   
7. AboutYouInterestsPage
   └─> Collect: interests
   └─> Navigate to AboutYouLookingForPage
   
8. AboutYouLookingForPage
   └─> Collect: looking_for
   └─> Navigate to AboutYouLocationPage
   
9. AboutYouLocationPage
   └─> Collect: location
   └─> 🚀 API CALL: POST /api/v1/auth/register/simple-register
   │   Request: {
   │     email, password, first_name, last_name, date_of_birth
   │   }
   │   Response: { token, user }
   └─> Store token in FlutterSecureStorage
   └─> Navigate to VerificationPromptPage
   
10. VerificationPromptPage
    └─> Option A: Skip verification → Home
    └─> Option B: Verify Identity
        └─> 🚀 API CALL: POST /api/v1/auth/verification/email/send
        └─> Navigate to OTPVerificationPage (to be created)
        
11. OTPVerificationPage (NEW - TO CREATE)
    └─> Show 6-digit code input
    └─> 🚀 API CALL: POST /api/v1/auth/verification/email/verify
    │   Request: { code: "123456" }
    │   Response: { email_verified: true }
    └─> Show success message
    └─> Navigate to Home
```

### Login Flow

```
┌─────────────────────────────────────────────────────────────┐
│ LOGIN FLOW - Frontend to Backend Integration               │
└─────────────────────────────────────────────────────────────┘

1. WelcomePage
   └─> Click "Log In"
   └─> Navigate to LoginPage

2. LoginPage
   └─> Collect: login (email/phone), password
   └─> Option A: Standard Login
   │   └─> 🚀 API CALL: POST /api/v1/auth/login
   │       Request: {
   │         login: "user@example.com",
   │         password: "Password123!",
   │         remember: true,
   │         device_token: "fcm_token"
   │       }
   │       Response: {
   │         token: "jwt_token",
   │         user: { ... }
   │       }
   │   └─> Store token in FlutterSecureStorage
   │   └─> Navigate to Home
   │
   └─> Option B: Google Login
   │   └─> Call Google Sign-In SDK
   │   └─> Get Google ID Token
   │   └─> 🚀 API CALL: POST /api/v1/auth/social/google
   │       Request: { token: "google_id_token" }
   │   └─> Store JWT token
   │   └─> Navigate to Home or Profile Setup (if new user)
   │
   └─> Option C: Forgot Password
       └─> Navigate to ForgotPasswordEmailPage
```

### Forgot Password Flow

```
┌─────────────────────────────────────────────────────────────┐
│ FORGOT PASSWORD FLOW - Frontend to Backend Integration     │
└─────────────────────────────────────────────────────────────┘

1. ForgotPasswordEmailPage
   └─> Collect: identifier (email or phone)
   └─> 🚀 API CALL: POST /api/v1/auth/password/forgot
   │   Request: { identifier: "user@example.com" }
   │   Response: {
   │     message: "Recovery code sent",
   │     delivery_method: "email"
   │   }
   └─> Navigate to ForgotPasswordCodePage

2. ForgotPasswordCodePage
   └─> Show 6-digit code input
   └─> User enters code
   └─> 🚀 API CALL: POST /api/v1/auth/verification/email/verify
   │   Request: { code: "123456" }
   │   Response: { verified: true, reset_token: "temp_token" }
   └─> Store reset_token temporarily
   └─> Navigate to ResetPasswordPage

3. ResetPasswordPage
   └─> Collect: new_password, confirm_password
   └─> 🚀 API CALL: PUT /api/v1/auth/password/change
   │   Headers: { Authorization: Bearer reset_token }
   │   Request: {
   │     new_password: "NewPassword123!",
   │     new_password_confirmation: "NewPassword123!"
   │   }
   │   Response: { message: "Password changed" }
   └─> Navigate to PasswordChangedPage

4. PasswordChangedPage
   └─> Show success message
   └─> Navigate to LoginPage
```

---

## 🎯 Priority Integration Tasks

### 🔴 HIGH PRIORITY (Must Implement First)

#### Task 1: Registration + Profile Setup
**Pages Involved**: 
- `create_password_page.dart`
- `about_you_*_page.dart` (6 pages)
- `account_created_page.dart`

**Endpoints**:
```
POST /api/v1/auth/register/simple-register
```

**Implementation Steps**:
1. Create `RegisterBloc` with events:
   - `RegisterStarted` - Collects all form data
   - `RegisterInProgress` - Shows loading
   - `RegisterSuccess` - Stores token, navigates
   - `RegisterFailure` - Shows error

2. Create data models:
   - `RegisterRequest.dart`
   - `RegisterResponse.dart`
   - `UserModel.dart`

3. Create `AuthRemoteDataSource`:
```dart
@POST('/auth/register/simple-register')
Future<RegisterResponse> register(@Body() RegisterRequest request);
```

4. Update `AboutYouLocationPage`:
   - Collect all data from previous pages
   - Call `registerBloc.add(RegisterStarted(data))`
   - Show loading indicator
   - Handle success/error states

**Estimated Time**: 4-6 hours

---

#### Task 2: Login Flow
**Pages Involved**:
- `login_page.dart`

**Endpoints**:
```
POST /api/v1/auth/login
POST /api/v1/auth/refresh-token (interceptor)
```

**Implementation Steps**:
1. Create `LoginBloc`
2. Create `LoginRequest` and `LoginResponse` models
3. Implement token storage with `FlutterSecureStorage`
4. Add auth interceptor for automatic token injection
5. Add token refresh logic
6. Update LoginPage to use BLoC

**Estimated Time**: 3-4 hours

---

#### Task 3: OTP Verification
**Pages Involved**:
- NEW: `otp_verification_page.dart` (to be created)
- `account_created_page.dart` (redirect)

**Endpoints**:
```
POST /api/v1/auth/verification/email/send
POST /api/v1/auth/verification/email/verify
POST /api/v1/auth/verification/phone/send
POST /api/v1/auth/verification/phone/verify
POST /api/v1/auth/verification/resend
```

**Implementation Steps**:
1. Create `OtpVerificationPage` UI:
   - 6-digit code input
   - Countdown timer (10 minutes)
   - Resend button (30s cooldown)
   - Error states

2. Create `OtpBloc`

3. Update `AccountCreatedPage`:
   - Instead of "Go to Home", navigate to OTP page
   - Call send verification automatically

**Estimated Time**: 3-4 hours

---

#### Task 4: Forgot Password Flow
**Pages Involved**:
- `forgot_password_email_page.dart`
- `forgot_password_code_page.dart`
- `reset_password_page.dart`
- `password_changed_page.dart`

**Endpoints**:
```
POST /api/v1/auth/password/forgot
POST /api/v1/auth/verification/email/verify
PUT /api/v1/auth/password/change
```

**Implementation Steps**:
1. Create `ForgotPasswordBloc`
2. Create request/response models
3. Integrate all 3 pages with backend
4. Handle edge cases (expired code, invalid email, etc.)

**Estimated Time**: 3-4 hours

---

### 🟡 MEDIUM PRIORITY (Implement After Core Features)

#### Task 5: Social Login (Google)
**Endpoints**:
```
POST /api/v1/auth/social/google
```

**Dependencies**:
- Configure Firebase project
- Set up Google OAuth credentials
- Test Google Sign-In flow

**Estimated Time**: 4-5 hours

---

#### Task 6: Identity Verification (Onfido)
**Endpoints**:
```
POST /api/v1/auth/verification/identity/workflow-run
GET /api/v1/auth/verification/identity/workflow-run/:id
```

**Dependencies**:
- Onfido SDK integration
- Onfido account setup
- Workflow configuration

**Estimated Time**: 6-8 hours

---

### 🟢 LOW PRIORITY (Future Features)

#### Task 7: Session Management
**Endpoints**:
```
GET /api/v1/auth/sessions
DELETE /api/v1/auth/sessions/:tokenId
POST /api/v1/auth/logout-all
```

**Estimated Time**: 2-3 hours

---

#### Task 8: Username Feature
**Endpoints**:
```
GET /api/v1/auth/register/check-username
GET /api/v1/auth/register/suggest-usernames
```

**Note**: Only if username feature is added to UI

**Estimated Time**: 2-3 hours

---

## 📦 Required Models (Data Layer)

### Request Models

```dart
// lib/features/auth/data/models/requests/

1. register_request.dart
   - email: String?
   - phone: String?
   - password: String
   - first_name: String
   - last_name: String
   - date_of_birth: String (YYYY-MM-DD)
   - gender: String?
   - interests: String?
   - looking_for: String?
   - location: String?

2. login_request.dart
   - login: String (email/phone/username)
   - password: String
   - remember: bool
   - device_token: String?

3. verify_code_request.dart
   - code: String (6 digits)

4. resend_code_request.dart
   - type: String (email/phone)

5. forgot_password_request.dart
   - identifier: String (email/phone)

6. change_password_request.dart
   - current_password: String?
   - new_password: String
   - new_password_confirmation: String

7. social_login_request.dart
   - token: String (Google/Facebook token)
```

### Response Models

```dart
// lib/features/auth/data/models/responses/

1. auth_response.dart (Generic)
   - token: String
   - user: UserModel
   - message: String?

2. verification_response.dart
   - message: String
   - verified: bool
   - expires_at: String?

3. user_model.dart
   - id: String
   - email: String?
   - phone: String?
   - first_name: String
   - last_name: String
   - date_of_birth: String
   - gender: String?
   - email_verified: bool
   - phone_verified: bool
   - created_at: String
```

---

## 🔧 Core Implementation Components

### 1. API Client Setup

```dart
// lib/core/network/auth_api_client.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi(baseUrl: "http://3.232.35.26:8000/api/v1")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  // Registration
  @POST("/auth/register/simple-register")
  Future<AuthResponse> register(@Body() RegisterRequest request);

  // Login
  @POST("/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);

  // Logout
  @POST("/auth/logout")
  Future<void> logout();

  // Token Refresh
  @POST("/auth/refresh-token")
  Future<AuthResponse> refreshToken();

  // Email Verification
  @POST("/auth/verification/email/send")
  Future<void> sendEmailVerification();

  @POST("/auth/verification/email/verify")
  Future<VerificationResponse> verifyEmailCode(@Body() VerifyCodeRequest request);

  // Phone Verification
  @POST("/auth/verification/phone/send")
  Future<void> sendPhoneVerification();

  @POST("/auth/verification/phone/verify")
  Future<VerificationResponse> verifyPhoneCode(@Body() VerifyCodeRequest request);

  // Resend Code
  @POST("/auth/verification/resend")
  Future<void> resendCode(@Body() ResendCodeRequest request);

  // Password Management
  @POST("/auth/password/forgot")
  Future<void> forgotPassword(@Body() ForgotPasswordRequest request);

  @PUT("/auth/password/change")
  Future<void> changePassword(@Body() ChangePasswordRequest request);

  // Social Auth
  @POST("/auth/social/google")
  Future<AuthResponse> googleLogin(@Body() SocialLoginRequest request);

  @POST("/auth/social/facebook")
  Future<AuthResponse> facebookLogin(@Body() SocialLoginRequest request);
}
```

### 2. Dio Configuration

```dart
// lib/core/network/dio_client.dart

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://3.232.35.26:8000/api/v1',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add Auth Interceptor
  dio.interceptors.add(AuthInterceptor());

  // Add Logger (development only)
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));
  }

  return dio;
}
```

### 3. Auth Interceptor (Token Management)

```dart
// lib/core/network/auth_interceptor.dart

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get token from storage
    final token = await _storage.read(key: 'auth_token');
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      try {
        // Try to refresh token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry original request
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Refresh failed, logout user
        await _logout();
      }
    }
    
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    // TODO: Implement token refresh
    return false;
  }

  Future<void> _logout() async {
    await _storage.delete(key: 'auth_token');
    // Navigate to login
  }
}
```

---

## 🧪 Testing Recommendations

### Test Each Endpoint

1. **Use Postman Collection**
   - Import `ForeverUsInLove_Auth_API.postman_collection.json`
   - Set `base_url` to `http://3.232.35.26:8000`
   - Test each endpoint manually first

2. **Test from Flutter**
   - Start with Login endpoint
   - Print full request/response
   - Verify token storage
   - Test token refresh

3. **Error Handling**
   - Test with wrong credentials
   - Test with expired codes
   - Test with network errors
   - Test with 401 unauthorized

---

## 📊 Integration Progress Tracker

### Completion Checklist

- [ ] **Setup**
  - [ ] Update base URL in code
  - [ ] Configure Dio client
  - [ ] Setup FlutterSecureStorage
  - [ ] Create AuthInterceptor
  - [ ] Generate Retrofit code

- [ ] **Registration Flow (40%)**
  - [ ] Create data models
  - [ ] Create RegisterBloc
  - [ ] Integrate RegisterEmailPage
  - [ ] Integrate CreatePasswordPage
  - [ ] Integrate About You pages
  - [ ] Store token after registration
  - [ ] Handle registration errors

- [ ] **Login Flow (0%)**
  - [ ] Create LoginBloc
  - [ ] Integrate LoginPage
  - [ ] Store token after login
  - [ ] Handle login errors
  - [ ] Implement "Remember Me"

- [ ] **OTP Verification (0%)**
  - [ ] Create OTPVerificationPage
  - [ ] Create OtpBloc
  - [ ] Integrate send code API
  - [ ] Integrate verify code API
  - [ ] Implement resend functionality
  - [ ] Add countdown timer
  - [ ] Handle verification errors

- [ ] **Forgot Password (0%)**
  - [ ] Create ForgotPasswordBloc
  - [ ] Integrate ForgotPasswordEmailPage
  - [ ] Integrate ForgotPasswordCodePage
  - [ ] Integrate ResetPasswordPage
  - [ ] Handle forgot password errors

- [ ] **Social Auth (0%)**
  - [ ] Setup Firebase
  - [ ] Integrate Google Sign-In
  - [ ] Integrate Facebook Login
  - [ ] Handle social auth errors

- [ ] **Session Management (0%)**
  - [ ] Implement token refresh
  - [ ] Implement logout
  - [ ] Add session list page
  - [ ] Add logout all functionality

---

## 🎉 Summary

**Total Endpoints**: 21
**High Priority**: 13 endpoints
**Medium Priority**: 4 endpoints  
**Low Priority**: 4 endpoints

**Estimated Total Time**: 25-35 hours for complete integration

---

**Ready to start integration?** 

Recommended starting point: **Task 1 - Registration + Profile Setup**

This will establish the foundation for:
- BLoC pattern implementation
- API client setup
- Token management
- Error handling
- Navigation flow

Once registration works, the other features will follow the same pattern and be much faster to implement.
