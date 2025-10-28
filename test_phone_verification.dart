import 'package:dio/dio.dart';
import 'package:forever_us_in_love/core/network/auth_api_client.dart';
import 'package:forever_us_in_love/core/network/dio_client.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/register_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/verify_code_request.dart';
import 'package:forever_us_in_love/features/auth/data/models/requests/resend_code_request.dart';

void main() async {
  final dio = DioClient.instance;
  final authApiClient = AuthApiClient(dio);

  print('Testing Phone Verification endpoints...\n');

  // Test 1: Test server connectivity
  try {
    print('1. Testing server connectivity...');
    final response = await dio.get('/auth/register/check-username', queryParameters: {'username': 'test'});
    print('✅ Server is reachable - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    print('❌ Server connectivity failed: $e\n');
  }

  // Test 2: Test registration with phone number
  try {
    print('2. Testing registration with phone number...');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final response = await dio.post('/auth/register/simple-register', data: {
      'phone': '+1234567890',
      'password': 'Password123!',
      'password_confirmation': 'Password123!',
      'first_name': 'Test',
      'last_name': 'User',
      'date_of_birth': '1990-01-01',
    });
    print('✅ Registration with phone successful - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Registration with phone failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Registration with phone failed: $e\n');
    }
  }

  // Test 3: Test phone verification send endpoint
  try {
    print('3. Testing phone verification send endpoint...');
    final response = await dio.post('/auth/verification/phone/send');
    print('✅ Phone verification send endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Phone verification send failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Phone verification send failed: $e\n');
    }
  }

  // Test 4: Test phone verification verify endpoint
  try {
    print('4. Testing phone verification verify endpoint...');
    final response = await dio.post('/auth/verification/phone/verify', data: {
      'code': '123456',
    });
    print('✅ Phone verification verify endpoint working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Phone verification verify failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Phone verification verify failed: $e\n');
    }
  }

  // Test 5: Test resend code endpoint for phone
  try {
    print('5. Testing resend code endpoint for phone...');
    final response = await dio.post('/auth/verification/resend', data: {
      'type': 'phone',
    });
    print('✅ Resend code for phone working - Status: ${response.statusCode}');
    print('Response: ${response.data}\n');
  } catch (e) {
    if (e is DioException) {
      print('❌ Resend code for phone failed: ${e.response?.statusCode} - ${e.response?.data}\n');
    } else {
      print('❌ Resend code for phone failed: $e\n');
    }
  }

  print('Phone verification endpoint testing completed!');
}
