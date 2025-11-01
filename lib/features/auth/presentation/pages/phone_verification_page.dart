import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

/// Phone Verification Screen
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Enter code" (Bold, Black)
/// - Subtitle: "We've sent a code to {phone}, write it here to verify your account"
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
/// - Integration with AuthRepository for verification
class PhoneVerificationPage extends StatefulWidget {
  final String phone;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String password;
  
  const PhoneVerificationPage({
    super.key,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.password,
  });

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
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
    
    // Auto-focus first field and send verification code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      _sendVerificationCode();
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
  
  Future<void> _sendVerificationCode() async {
    try {
      // Get auth repository
      final authRepository = GetIt.instance<AuthRepository>();
      
      // Send phone verification code
      final result = await authRepository.sendPhoneVerification();
      
      result.fold(
        (failure) {
          // Only show error message if there's actually a failure
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error sending code: ${failure.message}'),
                backgroundColor: _errorRed,
              ),
            );
          }
        },
        (_) {
          // Success - code sent silently, no need to show message
        },
      );
    } catch (e) {
      // Only show error if there's an exception
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending code: $e'),
            backgroundColor: _errorRed,
          ),
        );
      }
    }
  }
  
  Future<void> _handleResendCode() async {
    if (!_canResend) return;
    
    // Restart timer and send new code
    _startCountdown();
    
    // Clear all fields
    for (var controller in _controllers) {
      controller.clear();
    }
    
    setState(() {
      _validationState = 'normal';
      _errorMessage = '';
    });
    
    // Send verification code and show success message
    try {
      // Get auth repository
      final authRepository = GetIt.instance<AuthRepository>();
      
      // Send phone verification code
      final result = await authRepository.sendPhoneVerification();
      
      result.fold(
        (failure) {
          // Show error if sending fails
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error sending code: ${failure.message}'),
                backgroundColor: _errorRed,
              ),
            );
          }
        },
        (_) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('We\'ve sent you a new verification code via SMS/OTP.'),
                backgroundColor: _primaryGreen,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Show error if exception occurs
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending code: $e'),
            backgroundColor: _errorRed,
          ),
        );
      }
    }
    
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
  
  Future<void> _validateCode() async {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 6) {
      return;
    }
    
    setState(() {
      _validationState = 'normal';
      _errorMessage = '';
    });
    
    try {
      // Get auth repository
      final authRepository = GetIt.instance<AuthRepository>();
      
      // Verify phone code with real API
      final result = await authRepository.verifyPhoneCode(code);
      
      result.fold(
        (failure) {
          // Map error messages to specific user-friendly messages
          String errorMsg;
          final failureMsgLower = failure.message.toLowerCase();
          
          if (failureMsgLower.contains('expired') || failureMsgLower.contains('expir')) {
            errorMsg = 'The code has expired. Please request a new one to continue.';
          } else {
            errorMsg = 'Wrong code, please try again';
          }
          
          setState(() {
            _validationState = 'error';
            _errorMessage = errorMsg;
          });
        },
        (verified) {
          if (verified) {
            setState(() {
              _validationState = 'success';
              _errorMessage = '';
            });
            
            // Navigate to account created page after a delay
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  '/account-created',
                  arguments: {
                    'phone': widget.phone,
                    'firstName': widget.firstName,
                    'lastName': widget.lastName,
                    'dateOfBirth': widget.dateOfBirth,
                  },
                );
              }
            });
          } else {
            setState(() {
              _validationState = 'error';
              _errorMessage = 'Wrong code, please try again';
            });
          }
        },
      );
    } catch (e) {
      // Map exception to user-friendly message
      String errorMsg;
      final errorMsgLower = e.toString().toLowerCase();
      
      if (errorMsgLower.contains('expired') || errorMsgLower.contains('expir')) {
        errorMsg = 'The code has expired. Please request a new one to continue.';
      } else {
        errorMsg = 'Wrong code, please try again';
      }
      
      setState(() {
        _validationState = 'error';
        _errorMessage = errorMsg;
      });
    }
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
                  icon: Image.asset(
                    'assets/images/icons/back.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.arrow_back, color: _primaryGreen, size: 24);
                    },
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 16),
              // Step indicator
              Text(
                'Step 2/3 - Activate account',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  color: _primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Verify your account',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle with phone
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Delight',
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'We\'ve sent a code to ${widget.phone}, write it here '),
                    const TextSpan(
                      text: 'to activate',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' your account.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // OTP Input - 5 circular fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
