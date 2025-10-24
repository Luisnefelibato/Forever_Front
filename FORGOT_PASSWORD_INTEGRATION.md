# Forgot Password - Backend Integration Guide

## Overview
This document describes the backend integration requirements for the Forgot Password flow using SendGrid (Twilio).

## Flow Description

### 1. Request Password Reset (Email Entry Screen)
**Screen:** `forgot_password_email_page.dart`

**User Action:** User enters email/phone and taps "Continue"

**API Call Required:**
```dart
POST /api/auth/forgot-password
Content-Type: application/json

Request Body:
{
  "email": "user@example.com"  // or phone number
}

Expected Response (Success):
{
  "success": true,
  "message": "Recovery code sent successfully",
  "email": "user@example.com",
  "expiresIn": 300  // seconds (5 minutes)
}

Expected Response (Error):
{
  "success": false,
  "error": "Email not found"
}
```

**Backend Actions:**
1. Validate email/phone exists in database
2. Generate 5-digit OTP code (e.g., "15304")
3. Store OTP with expiration time (5 minutes) in Redis/cache
4. Send email via SendGrid with template:
   - Subject: "ForeverUsInLove - Password Recovery Code"
   - Body: "Your recovery code is: **15304**"
   - Template should include branding and code validity time
5. Return success response

**SendGrid Implementation:**
```javascript
// Node.js example
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const msg = {
  to: 'user@example.com',
  from: 'noreply@foreverusinlove.com', // verified sender
  subject: 'ForeverUsInLove - Password Recovery Code',
  text: `Your recovery code is: ${otpCode}. Valid for 5 minutes.`,
  html: `
    <div style="font-family: Arial, sans-serif;">
      <h2>Password Recovery</h2>
      <p>Your recovery code is:</p>
      <h1 style="color: #2CA97B; font-size: 32px;">${otpCode}</h1>
      <p>This code will expire in 5 minutes.</p>
      <p>If you didn't request this code, please ignore this email.</p>
    </div>
  `,
};

await sgMail.send(msg);
```

---

### 2. Verify OTP Code (Code Entry Screen)
**Screen:** `forgot_password_code_page.dart`

**User Action:** User enters 5-digit code

**API Call Required:**
```dart
POST /api/auth/verify-reset-code
Content-Type: application/json

Request Body:
{
  "email": "user@example.com",
  "code": "15304"
}

Expected Response (Success):
{
  "success": true,
  "message": "Code verified successfully",
  "resetToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."  // JWT token for password reset
}

Expected Response (Error - Wrong Code):
{
  "success": false,
  "error": "Invalid code"
}

Expected Response (Error - Expired):
{
  "success": false,
  "error": "Code expired"
}
```

**Backend Actions:**
1. Retrieve OTP from cache using email as key
2. Validate code matches and not expired
3. Generate short-lived JWT token (15 minutes) for password reset
4. Return token to be used in next step
5. Mark OTP as used (prevent reuse)

---

### 3. Resend Code
**Screen:** `forgot_password_code_page.dart`

**User Action:** User taps "Send code again" after timer expires

**API Call Required:**
```dart
POST /api/auth/resend-reset-code
Content-Type: application/json

Request Body:
{
  "email": "user@example.com"
}

Expected Response:
{
  "success": true,
  "message": "New code sent successfully",
  "expiresIn": 300
}
```

**Backend Actions:**
1. Invalidate previous OTP
2. Generate new 5-digit OTP
3. Store new OTP with expiration
4. Send new email via SendGrid
5. Return success response

---

## Flutter Implementation Points

### 1. In `forgot_password_email_page.dart`

Replace the TODO section in `_handleContinue()`:
```dart
void _handleContinue() async {
  // ... validation code ...
  
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });
    
    try {
      // API call using Dio
      final response = await dio.post('/api/auth/forgot-password', data: {
        'email': email,
      });
      
      if (response.data['success']) {
        // Navigate to code entry screen
        Navigator.pushNamed(
          context,
          '/forgot-password-code',
          arguments: {'email': email},
        );
      }
    } on DioException catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = e.response?.data['error'] ?? 'An error occurred';
        _isLoading = false;
      });
    }
  }
}
```

### 2. In `forgot_password_code_page.dart`

Replace the TODO section in `_validateCode()`:
```dart
void _validateCode() async {
  final code = _controllers.map((c) => c.text).join();
  
  if (code.length != 5) return;
  
  try {
    final response = await dio.post('/api/auth/verify-reset-code', data: {
      'email': widget.email,
      'code': code,
    });
    
    if (response.data['success']) {
      setState(() {
        _validationState = 'success';
      });
      
      // Store reset token for next screen
      final resetToken = response.data['resetToken'];
      
      // Navigate to reset password screen after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/reset-password',
            arguments: {'resetToken': resetToken},
          );
        }
      });
    }
  } on DioException catch (e) {
    setState(() {
      _validationState = 'error';
      _errorMessage = e.response?.data['error'] ?? 'Wrong code, please try again';
    });
  }
}
```

Replace the TODO section in `_handleResendCode()`:
```dart
void _handleResendCode() async {
  if (!_canResend) return;
  
  try {
    await dio.post('/api/auth/resend-reset-code', data: {
      'email': widget.email,
    });
    
    // Restart timer and clear fields
    _startCountdown();
    for (var controller in _controllers) {
      controller.clear();
    }
    
    setState(() {
      _validationState = 'normal';
    });
    
    _focusNodes[0].requestFocus();
    
  } on DioException catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.response?.data['error'] ?? 'Failed to resend code')),
    );
  }
}
```

---

## SendGrid Configuration

### Environment Variables Required:
```env
SENDGRID_API_KEY=SG.xxxxxxxxxxxxxxxxxxxx
SENDGRID_FROM_EMAIL=noreply@foreverusinlove.com
SENDGRID_FROM_NAME=ForeverUsInLove
```

### SendGrid Setup Steps:
1. Create SendGrid account at https://sendgrid.com
2. Verify sender email address (noreply@foreverusinlove.com)
3. Generate API key with "Mail Send" permissions
4. Create email template (optional) for branded emails
5. Configure environment variables in backend

### Rate Limiting:
- Implement rate limiting to prevent abuse
- Max 3 code requests per email per hour
- Max 5 verification attempts before lockout

---

## Security Considerations

1. **OTP Generation:**
   - Use cryptographically secure random number generator
   - 5-digit numeric code (10000-99999)
   - Store hashed version in database

2. **Expiration:**
   - OTP valid for 5 minutes only
   - Invalidate after successful use
   - Clear expired OTPs from cache regularly

3. **Rate Limiting:**
   - Limit requests per IP and per email
   - Implement exponential backoff on failed attempts
   - CAPTCHA after multiple failed attempts

4. **Email Validation:**
   - Verify email exists before sending code
   - Don't reveal if email exists (security)
   - Log all password reset attempts

---

## Testing

### Test Cases:

1. **Valid Email:**
   - Input: existing email
   - Expected: Code sent, navigate to OTP screen

2. **Invalid Email:**
   - Input: non-existent email
   - Expected: Generic error message

3. **Valid OTP:**
   - Input: correct 5-digit code
   - Expected: "Approved!" message, navigate to reset password

4. **Invalid OTP:**
   - Input: wrong code
   - Expected: Red borders, "Wrong code, please try again"

5. **Expired OTP:**
   - Wait 5+ minutes
   - Expected: "Code expired" error

6. **Resend Code:**
   - Wait 20 seconds
   - Tap "Send code again"
   - Expected: New code sent, timer restarts

### Mock API for Testing:
```dart
// For development only
class MockAuthAPI {
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    await Future.delayed(Duration(seconds: 1));
    return {'success': true, 'email': email, 'expiresIn': 300};
  }
  
  static Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    await Future.delayed(Duration(seconds: 1));
    if (code == '15304') {
      return {'success': true, 'resetToken': 'mock_token_12345'};
    }
    return {'success': false, 'error': 'Invalid code'};
  }
}
```

---

## Next Steps

1. ✅ Create UI screens (COMPLETED)
2. 🔲 Implement backend endpoints
3. 🔲 Configure SendGrid
4. 🔲 Integrate API calls in Flutter
5. 🔲 Create Reset Password screen
6. 🔲 Test complete flow
7. 🔲 Add analytics tracking

---

## Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/auth/forgot-password` | POST | Request password reset |
| `/api/auth/verify-reset-code` | POST | Verify OTP code |
| `/api/auth/resend-reset-code` | POST | Resend OTP code |
| `/api/auth/reset-password` | POST | Set new password (future) |

---

## Contact
For backend integration questions, refer to the API documentation or contact the backend team.
