import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

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
  Timer? _errorTimer;
  Timer? _expirationTimer;
  int _remainingSeconds = 30;
  bool _canResend = false;
  
  String _validationState = 'normal'; // 'normal', 'error', 'success'
  String _errorMessage = '';
  bool _showWrongCodeError = false;
  bool _showExpirationWarning = false;
  bool _showExpirationMessage = false;
  bool _codeExpired = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  
  // TEST DATA - Remove in production
  static const String _testEmail = 'test@example.com';
  static const String _testPhone = '1234567890'; // 10 dígitos para pruebas
  static const String _testCorrectCode = '123456'; // Código correcto para pruebas
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      _sendVerificationCode();
    });
  }
  
  Future<void> _sendVerificationCode() async {
    // TEST MODE - Backend call commented for testing
    // TODO: Uncomment in production
    // try {
    //   final authRepository = GetIt.instance<AuthRepository>();
    //   final result = await authRepository.forgotPassword(widget.identifier);
    //   
    //   result.fold(
    //     (failure) {
    //       if (mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text('Error sending code: ${failure.message}'),
    //             backgroundColor: _errorRed,
    //           ),
    //         );
    //       }
    //     },
    //     (_) {
    //       // Success - code sent silently
    //     },
    //   );
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Error sending code: $e'),
    //         backgroundColor: _errorRed,
    //       ),
    //     );
    //   }
    // }
    
    // TEST MODE - Simulate code sent successfully
    // In test mode, the code is always: 123456
    print('TEST MODE: Code would be sent to ${widget.identifier}');
    print('TEST MODE: Use code: $_testCorrectCode to test success scenario');
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _errorTimer?.cancel();
    _expirationTimer?.cancel();
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
      _codeExpired = false;
      _showExpirationWarning = false;
      _showExpirationMessage = false;
    });
    
    _timer?.cancel();
    _expirationTimer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // Timer reached 0 - start expiration sequence
        setState(() {
          _codeExpired = true;
          _showExpirationWarning = true;
          _canResend = false; // Will be true after expiration sequence
        });
        
        // After 2 seconds, show expiration message
        _expirationTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showExpirationWarning = false;
              _showExpirationMessage = true;
            });
            
            // After another 2 seconds, hide expiration message and show resend option
            _expirationTimer = Timer(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _showExpirationMessage = false;
                  _canResend = true;
                });
              }
            });
          }
        });
        
        timer.cancel();
      }
    });
  }
  
  Future<void> _handleResendCode() async {
    if (!_canResend) return;
    
    // Restart timer
    _startCountdown();
    
    // Clear all fields
    for (var controller in _controllers) {
      controller.clear();
    }
    
    setState(() {
      _validationState = 'normal';
      _errorMessage = '';
      _showWrongCodeError = false;
      _codeExpired = false;
      _showExpirationWarning = false;
      _showExpirationMessage = false;
    });
    
    // TEST MODE - Backend call commented for testing
    // TODO: Uncomment in production
    // try {
    //   final authRepository = GetIt.instance<AuthRepository>();
    //   final result = await authRepository.forgotPassword(widget.identifier);
    //   
    //   result.fold(
    //     (failure) {
    //       if (mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text('Error sending code: ${failure.message}'),
    //             backgroundColor: _errorRed,
    //           ),
    //         );
    //       }
    //     },
    //     (_) {
    //       if (mounted) {
    //         final isEmail = widget.identifier.contains('@');
    //         final message = isEmail
    //             ? 'We\'ve sent you a new verification code via Email'
    //             : 'We\'ve sent you a new verification code via SMS/OTP.';
    //         
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(message),
    //             backgroundColor: _primaryGreen,
    //           ),
    //         );
    //       }
    //     },
    //   );
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Error sending code: $e'),
    //         backgroundColor: _errorRed,
    //       ),
    //     );
    //   }
    // }
    
    // TEST MODE - Simulate resend code
    if (mounted) {
      final isEmail = widget.identifier.contains('@');
      final message = isEmail
          ? 'We\'ve sent you a new verification code via Email'
          : 'We\'ve sent you a new verification code via SMS/OTP.';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _primaryGreen,
        ),
      );
      
      print('TEST MODE: Resend code to ${widget.identifier}');
      print('TEST MODE: Use code: $_testCorrectCode to test success scenario');
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
    
    // Clear any previous error states
    _errorTimer?.cancel();
    setState(() {
      _validationState = 'normal';
      _errorMessage = '';
      _showWrongCodeError = false;
    });
    
    // TEST MODE - Simulate validation without backend
    // TODO: Uncomment backend validation in production
    // try {
    //   final authRepository = GetIt.instance<AuthRepository>();
    //   final result = await authRepository.verifyRegisterOtp(
    //     identifier: widget.identifier,
    //     code: code,
    //   );
    //   
    //   result.fold(
    //     (failure) {
    //       String errorMsg;
    //       final failureMsgLower = failure.message.toLowerCase();
    //       
    //       if (failureMsgLower.contains('expired') || failureMsgLower.contains('expir')) {
    //         errorMsg = 'The code has expired. Please request a new one to continue.';
    //         setState(() {
    //           _validationState = 'error';
    //           _errorMessage = errorMsg;
    //           _codeExpired = true;
    //         });
    //       } else {
    //         errorMsg = 'Wrong code, please try again';
    //         _handleWrongCode();
    //       }
    //     },
    //     (verified) {
    //       if (verified) {
    //         setState(() {
    //           _validationState = 'success';
    //           _errorMessage = '';
    //         });
    //         
    //         Future.delayed(const Duration(milliseconds: 500), () {
    //           if (mounted) {
    //             Navigator.pushReplacementNamed(
    //               context,
    //               '/reset-password',
    //               arguments: {
    //                 'identifier': widget.identifier,
    //                 'code': code,
    //               },
    //             );
    //           }
    //         });
    //       } else {
    //         _handleWrongCode();
    //       }
    //     },
    //   );
    // } catch (e) {
    //   setState(() {
    //     _validationState = 'success';
    //     _errorMessage = '';
    //   });
    //   
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     if (mounted) {
    //       Navigator.pushReplacementNamed(
    //         context,
    //         '/reset-password',
    //         arguments: {
    //           'identifier': widget.identifier,
    //           'code': code,
    //         },
    //       );
    //     }
    //   });
    // }
    
    // Simulate validation delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if code matches test code
    if (code == _testCorrectCode) {
      // Code is correct - show success
      setState(() {
        _validationState = 'success';
        _errorMessage = '';
      });
      
      // Navigate to reset password screen after showing success
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/reset-password',
            arguments: {
              'identifier': widget.identifier,
              'code': code,
            },
          );
        }
      });
    } else {
      // Code is incorrect - show error
      _handleWrongCode();
    }
  }
  
  void _handleWrongCode() {
    setState(() {
      _validationState = 'error';
      _errorMessage = 'Wrong code, please try again';
      _showWrongCodeError = true;
    });
    
    // Clear error after 2 seconds
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showWrongCodeError = false;
          _validationState = 'normal';
        });
        // Clear all fields
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
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
              
              // Subtitle with identifier
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Delight',
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'We\'ve sent a code to ${widget.identifier}, write it here '),
                    const TextSpan(
                      text: 'to recover',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' your account.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // OTP Input - 6 circular fields
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
              
              // Countdown timer / Resend button / Error message / Expiration messages
              Center(
                child: Column(
                  children: [
                    // Wrong code error (shows for 2 seconds then disappears)
                    if (_showWrongCodeError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Wrong code, please try again',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            color: _errorRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    // Expiration warning (first message when timer expires)
                    if (_showExpirationWarning && !_showExpirationMessage)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'The code has expired',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            color: _errorRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    // Expiration message (after 2 seconds of warning)
                    if (_showExpirationMessage)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'The code has expired. Please request a new one to continue.',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            color: _errorRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    // Countdown timer or Resend CTA
                    // Show countdown if timer is still running
                    // Show resend if timer expired and expiration sequence is complete
                    if (!_showExpirationWarning && !_showExpirationMessage && !_showWrongCodeError)
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
