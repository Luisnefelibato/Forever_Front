import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  
  print('Testing Phone Verification endpoints...\n');

  try {
    // Test 1: Test server connectivity
    print('1. Testing server connectivity...');
    final request1 = await client.getUrl(Uri.parse('http://3.232.35.26:8000/api/v1/auth/register/check-username?username=test'));
    final response1 = await request1.close();
    final body1 = await response1.transform(utf8.decoder).join();
    print('✅ Server is reachable - Status: ${response1.statusCode}');
    print('Response: $body1\n');
  } catch (e) {
    print('❌ Server connectivity failed: $e\n');
  }

  try {
    // Test 2: Test registration with phone number
    print('2. Testing registration with phone number...');
    final request2 = await client.postUrl(Uri.parse('http://3.232.35.26:8000/api/v1/auth/register/simple-register'));
    request2.headers.set('Content-Type', 'application/json');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data2 = {
      'phone': '+1234567890',
      'password': 'Password123!',
      'password_confirmation': 'Password123!',
      'first_name': 'Test',
      'last_name': 'User',
      'date_of_birth': '1990-01-01',
    };
    request2.write(jsonEncode(data2));
    final response2 = await request2.close();
    final body2 = await response2.transform(utf8.decoder).join();
    print('✅ Registration with phone successful - Status: ${response2.statusCode}');
    print('Response: $body2\n');
  } catch (e) {
    print('❌ Registration with phone failed: $e\n');
  }

  try {
    // Test 3: Test phone verification send endpoint
    print('3. Testing phone verification send endpoint...');
    final request3 = await client.postUrl(Uri.parse('http://3.232.35.26:8000/api/v1/auth/verification/phone/send'));
    request3.headers.set('Content-Type', 'application/json');
    final response3 = await request3.close();
    final body3 = await response3.transform(utf8.decoder).join();
    print('✅ Phone verification send endpoint working - Status: ${response3.statusCode}');
    print('Response: $body3\n');
  } catch (e) {
    print('❌ Phone verification send failed: $e\n');
  }

  try {
    // Test 4: Test phone verification verify endpoint
    print('4. Testing phone verification verify endpoint...');
    final request4 = await client.postUrl(Uri.parse('http://3.232.35.26:8000/api/v1/auth/verification/phone/verify'));
    request4.headers.set('Content-Type', 'application/json');
    final data4 = {'code': '123456'};
    request4.write(jsonEncode(data4));
    final response4 = await request4.close();
    final body4 = await response4.transform(utf8.decoder).join();
    print('✅ Phone verification verify endpoint working - Status: ${response4.statusCode}');
    print('Response: $body4\n');
  } catch (e) {
    print('❌ Phone verification verify failed: $e\n');
  }

  try {
    // Test 5: Test resend code endpoint for phone
    print('5. Testing resend code endpoint for phone...');
    final request5 = await client.postUrl(Uri.parse('http://3.232.35.26:8000/api/v1/auth/verification/resend'));
    request5.headers.set('Content-Type', 'application/json');
    final data5 = {'type': 'phone'};
    request5.write(jsonEncode(data5));
    final response5 = await request5.close();
    final body5 = await response5.transform(utf8.decoder).join();
    print('✅ Resend code for phone working - Status: ${response5.statusCode}');
    print('Response: $body5\n');
  } catch (e) {
    print('❌ Resend code for phone failed: $e\n');
  }

  client.close();
  print('Phone verification endpoint testing completed!');
}
