import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://3.232.35.26:8000/api/v1',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  print('🔐 Testing ALL Authentication Endpoints');
  print('Server: http://3.232.35.26:8000/api/v1');
  print('=' * 60);
  
  String? authToken;
  String? sessionId;
  String? deviceId;
  String testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
  String testPhone = '+1234567890';
  String testPassword = 'Password123!';

  // Helper function to test endpoints
  Future<void> testEndpoint(String name, String method, String endpoint, Map<String, dynamic>? data, Map<String, String>? headers) async {
    try {
      print('\n📡 Testing: $name');
      print('   $method $endpoint');
      
      Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get(endpoint, options: Options(headers: headers));
          break;
        case 'POST':
          response = await dio.post(endpoint, data: data, options: Options(headers: headers));
          break;
        case 'DELETE':
          response = await dio.delete(endpoint, options: Options(headers: headers));
          break;
        default:
          throw Exception('Unsupported method: $method');
      }
      
      print('   ✅ Status: ${response.statusCode}');
      print('   📄 Response: ${response.data}');
      
      // Extract token if present
      if (response.data is Map && response.data['token'] != null) {
        authToken = response.data['token'];
        print('   🔑 Token extracted for future requests');
      }
      
      // Extract session info if present
      if (response.data is Map && response.data['session_id'] != null) {
        sessionId = response.data['session_id'];
        print('   🎫 Session ID extracted: $sessionId');
      }
      
      if (response.data is Map && response.data['device_id'] != null) {
        deviceId = response.data['device_id'];
        print('   📱 Device ID extracted: $deviceId');
      }
      
    } catch (e) {
      if (e is DioException) {
        print('   ❌ Status: ${e.response?.statusCode}');
        print('   📄 Error: ${e.response?.data}');
      } else {
        print('   ❌ Error: $e');
      }
    }
  }

  // ==========================================
  // 1. REGISTRATION ENDPOINTS (3 endpoints)
  // ==========================================
  print('\n🏗️  REGISTRATION ENDPOINTS');
  print('-' * 40);
  
  await testEndpoint(
    'Simple Registration',
    'POST',
    '/auth/register/simple-register',
    {
      'email': testEmail,
      'phone': testPhone,
      'password': testPassword,
      'password_confirmation': testPassword,
      'first_name': 'Test',
      'last_name': 'User',
      'date_of_birth': '1990-01-01',
    },
    null,
  );

  await testEndpoint(
    'Registration with Email Verification',
    'POST',
    '/auth/register/with-email-verification',
    {
      'email': 'verify${DateTime.now().millisecondsSinceEpoch}@example.com',
      'phone': '+1234567891',
      'password': testPassword,
      'password_confirmation': testPassword,
      'first_name': 'Email',
      'last_name': 'Verify',
      'date_of_birth': '1990-01-01',
    },
    null,
  );

  await testEndpoint(
    'Registration with Phone Verification',
    'POST',
    '/auth/register/with-phone-verification',
    {
      'email': 'phone${DateTime.now().millisecondsSinceEpoch}@example.com',
      'phone': '+1234567892',
      'password': testPassword,
      'password_confirmation': testPassword,
      'first_name': 'Phone',
      'last_name': 'Verify',
      'date_of_birth': '1990-01-01',
    },
    null,
  );

  // ==========================================
  // 2. LOGIN & LOGOUT ENDPOINTS (6 endpoints)
  // ==========================================
  print('\n🔑 LOGIN & LOGOUT ENDPOINTS');
  print('-' * 40);

  await testEndpoint(
    'Login with Email',
    'POST',
    '/auth/login',
    {
      'login': testEmail,
      'password': testPassword,
      'remember': true,
    },
    null,
  );

  await testEndpoint(
    'Login with Phone',
    'POST',
    '/auth/login',
    {
      'login': testPhone,
      'password': testPassword,
      'remember': true,
    },
    null,
  );

  await testEndpoint(
    'Login with Username',
    'POST',
    '/auth/login',
    {
      'login': 'testuser',
      'password': testPassword,
      'remember': true,
    },
    null,
  );

  // Use auth token for authenticated endpoints
  Map<String, String>? authHeaders = authToken != null ? {'Authorization': 'Bearer $authToken'} : null;

  await testEndpoint(
    'List Active Sessions',
    'GET',
    '/auth/sessions',
    null,
    authHeaders,
  );

  await testEndpoint(
    'Logout Current Session',
    'POST',
    '/auth/logout',
    null,
    authHeaders,
  );

  await testEndpoint(
    'Logout All Devices',
    'POST',
    '/auth/logout/all-devices',
    null,
    authHeaders,
  );

  await testEndpoint(
    'Logout Specific Device',
    'POST',
    '/auth/logout/device/test-device-123',
    null,
    authHeaders,
  );

  await testEndpoint(
    'Delete Session',
    'DELETE',
    '/auth/sessions/test-session-123',
    null,
    authHeaders,
  );

  // ==========================================
  // 3. VERIFICATION ENDPOINTS (7 endpoints)
  // ==========================================
  print('\n📧 VERIFICATION ENDPOINTS');
  print('-' * 40);

  await testEndpoint(
    'Send Email Verification Code',
    'POST',
    '/auth/verification/email/send',
    {'email': testEmail},
    authHeaders,
  );

  await testEndpoint(
    'Verify Email Code',
    'POST',
    '/auth/verification/email/verify',
    {
      'email': testEmail,
      'code': '123456',
    },
    authHeaders,
  );

  await testEndpoint(
    'Resend Email Code',
    'POST',
    '/auth/verification/email/resend',
    {'email': testEmail},
    authHeaders,
  );

  await testEndpoint(
    'Check Email Status',
    'GET',
    '/auth/verification/email/status',
    null,
    authHeaders,
  );

  await testEndpoint(
    'Send Phone Verification Code',
    'POST',
    '/auth/verification/phone/send',
    {'phone': testPhone},
    authHeaders,
  );

  await testEndpoint(
    'Verify Phone Code',
    'POST',
    '/auth/verification/phone/verify',
    {
      'phone': testPhone,
      'code': '123456',
    },
    authHeaders,
  );

  await testEndpoint(
    'Resend Phone Code',
    'POST',
    '/auth/verification/phone/resend',
    {'phone': testPhone},
    authHeaders,
  );

  // ==========================================
  // 4. PASSWORD MANAGEMENT (3 endpoints)
  // ==========================================
  print('\n🔒 PASSWORD MANAGEMENT ENDPOINTS');
  print('-' * 40);

  await testEndpoint(
    'Request Password Reset',
    'POST',
    '/auth/password/forgot',
    {'email': testEmail},
    null,
  );

  await testEndpoint(
    'Reset Password with Token',
    'POST',
    '/auth/password/reset',
    {
      'email': testEmail,
      'token': 'test-reset-token',
      'password': 'NewPassword123!',
      'password_confirmation': 'NewPassword123!',
    },
    null,
  );

  await testEndpoint(
    'Change Password (Authenticated)',
    'POST',
    '/auth/password/change',
    {
      'current_password': testPassword,
      'password': 'NewPassword123!',
      'password_confirmation': 'NewPassword123!',
    },
    authHeaders,
  );

  // ==========================================
  // 5. SOCIAL AUTHENTICATION (2 endpoints)
  // ==========================================
  print('\n🌐 SOCIAL AUTHENTICATION ENDPOINTS');
  print('-' * 40);

  await testEndpoint(
    'Google OAuth Login/Register',
    'POST',
    '/auth/social/google',
    {
      'access_token': 'test-google-token',
      'id_token': 'test-google-id-token',
    },
    null,
  );

  await testEndpoint(
    'Apple OAuth Login/Register',
    'POST',
    '/auth/social/apple',
    {
      'identity_token': 'test-apple-token',
      'authorization_code': 'test-apple-code',
    },
    null,
  );

  // ==========================================
  // SUMMARY
  // ==========================================
  print('\n' + '=' * 60);
  print('🎯 TESTING COMPLETED');
  print('=' * 60);
  print('📊 Total Endpoints Tested: 21');
  print('🔑 Login & Logout: 6 endpoints');
  print('🏗️  Registration: 3 endpoints');
  print('📧 Verification: 7 endpoints');
  print('🔒 Password Management: 3 endpoints');
  print('🌐 Social Authentication: 2 endpoints');
  print('\n💡 Check the results above for any failed endpoints');
  print('🔍 Look for ❌ symbols to identify issues');
}
