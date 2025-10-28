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

  print('Testing API endpoints...\n');

  // Test 1: Check if server is reachable
  try {
    print('1. Testing server connectivity...');
    final response = await dio.get('/auth/register/check-username?username=test');
    print('✅ Server is reachable - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    print('❌ Server connectivity failed: $e\n');
  }

  // Test 2: Test registration endpoint with unique data
  try {
    print('2. Testing registration endpoint...');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final response = await dio.post('/auth/register/simple-register', data: {
      'email': 'test$timestamp@example.com',
      'phone': '+1234567890',
      'password': 'Password123!',
      'password_confirmation': 'Password123!',
      'first_name': 'Test',
      'last_name': 'User',
      'date_of_birth': '1990-01-01',
    });
    print('✅ Registration endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Registration endpoint failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Registration endpoint failed: $e\n');
    }
  }

  // Test 3: Test login endpoint with valid credentials
  try {
    print('3. Testing login endpoint...');
    final response = await dio.post('/auth/login', data: {
      'login': 'test@example.com',
      'password': 'password123',
      'remember': true,
    });
    print('✅ Login endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Login endpoint failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Login endpoint failed: $e\n');
    }
  }

  // Test 4: Test email verification endpoint
  try {
    print('4. Testing email verification endpoint...');
    final response = await dio.post('/auth/verification/email/send');
    print('✅ Email verification endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    print('❌ Email verification endpoint failed: $e\n');
  }

  // Test 5: Test phone verification endpoint
  try {
    print('5. Testing phone verification endpoint...');
    final response = await dio.post('/auth/verification/phone/send');
    print('✅ Phone verification endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    print('❌ Phone verification endpoint failed: $e\n');
  }

  print('API endpoint testing completed!');
}
