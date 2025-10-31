import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

/// Forgot Password - Code Verification Screen
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Enter code" (Bold, Black)
/// - Subtitle: "We've sent a code to {email}, write it here to recover your account"
/// - OTP Input: 5 circular input fields with borders
/// - Countdown timer: "Send code again 00:30" (gray text)
/// - Error state: Red borders + "Wrong code, please try again" message
/// - Success state: Green borders + "Approved!" message
/// 
/// Features:
/// - Auto-focus next field on digit entry
/// - Countdown timer (30 seconds)
/// - Resend code button after timer expires
/// - Auto-validation when all 5 digits entered
class ForgotPasswordCodePage extends StatefulWidget {
  final String identifier;
  
  const ForgotPasswordCodePage({
    super.key,
    required this.identifier,
  });

  @override
  State<ForgotPasswordCodePage> createState() => _ForgotPasswordCodePageState();
}

class _ForgotPasswordCodePageState extends State<ForgotPasswordCodePage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  Timer? _timer;
  int _remainingSeconds = 30;
  bool _canResend = false;
  
  String _validationState = 'normal'; // 'normal', 'error', 'success'
  String _errorMessage = '';
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  void _startCountdown() {
    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }
  
  void _handleResendCode() {
    if (!_canResend) return;
    
    // TODO: Implement actual API call to resend code
    // For now, just restart the timer
    _startCountdown();
    
    // Clear all fields
    for (var controller in _controllers) {
      controller.clear();
    }
    
    setState(() {
      _validationState = 'normal';
      _errorMessage = '';
    });
    
    // Focus first field
    _focusNodes[0].requestFocus();
  }
  
  void _onDigitChanged(int index, String value) {
    if (value.isEmpty) {
      // Handle backspace - move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled - validate code
        _validateCode();
      }
    }
  }
  
  void _validateCode() {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 6) {
      return;
    }
    
    // Navigate to reset password screen (verification occurs on reset)
    Navigator.pushReplacementNamed(
      context,
      '/reset-password',
      arguments: {
        'identifier': widget.identifier,
        'code': code,
      },
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  Color _getBorderColor() {
    switch (_validationState) {
      case 'error':
        return _errorRed;
      case 'success':
        return _primaryGreen;
      default:
        return Colors.black;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _primaryGreen, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: _primaryGreen),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Enter code',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle with email
              Text(
                'We\'ve sent a code to ${widget.identifier}, write it here to recover your account',
                style: const TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // OTP Input - 6 circular fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 72,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onDigitChanged(index, value),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: _getBorderColor(),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: _getBorderColor(),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 24),
              
              // Success message
              if (_validationState == 'success')
                Center(
                  child: Text(
                    'Approved!',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 14,
                      color: _primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Countdown timer / Resend button / Error message
              Center(
                child: Column(
                  children: [
                    // Error message (only show if there's an error)
                    if (_validationState == 'error')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            color: _errorRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    // Countdown timer or Resend CTA
                    _canResend
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Delight',
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              children: [
                                const TextSpan(text: 'I didn\u2019t receive a code '),
                                TextSpan(
                                  text: 'Resend',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _handleResendCode,
                                ),
                              ],
                            ),
                          )
                        : Text(
                            'Send code again  ${_formatTime(_remainingSeconds)}',
                            style: TextStyle(
                              fontFamily: 'Delight',
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
