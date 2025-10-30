import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

/// Forgot Password - Email Entry Screen
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Forgot password?" (Bold, Black)
/// - Subtitle: "Don't worry! It happens. Please enter the email or mobile number associated with your account."
/// - Input field: Rounded with black border (red when error)
/// - Continue button: Green #2CA97B, full width, positioned at bottom
/// - Error state: Pink background alert with red icon
/// 
/// Validations:
/// - Email/Phone: Required, valid format
/// - Shows error alert if empty on submit
class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() => _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _showError = false;
  String _errorMessage = '';
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _handleContinue() async {
    setState(() {
      _showError = false;
    });
    
    // Check if field is empty
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Complete one of the fields to continue';
      });
      return;
    }
    
    // Validate format
    if (_formKey.currentState!.validate()) {
      final identifier = _emailController.text.trim();
      try {
        // Send recovery code
        final authRepository = GetIt.instance<AuthRepository>();
        final result = await authRepository.forgotPassword(identifier);
        result.fold(
          (failure) {
            setState(() {
              _showError = true;
              _errorMessage = failure.message;
            });
          },
          (_) {
            Navigator.pushNamed(
              context,
              '/forgot-password-code',
              arguments: {'identifier': identifier},
            );
          },
        );
      } catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = 'Failed to send recovery code. Please try again.';
        });
      }
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter a valid email or phone number';
      });
    }
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    
    // Check if it's a phone number (10 digits for Colombian format)
    final phoneRegex = RegExp(r'^\d{10}$');
    if (phoneRegex.hasMatch(value)) {
      return null; // Valid phone number
    }
    
    // Check if it's a valid email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email or phone number';
    }
    
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
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
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Subtitle
                      const Text(
                        'Don\'t worry! It happens. Please enter the email or mobile number associated with your account.',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Email address label
                      const Text(
                        'Email or phone number',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Email input field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          // Clear error when user starts typing
                          if (_showError) {
                            setState(() {
                              _showError = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Example@email.com or +1 555-123-4567',
                          hintStyle: TextStyle(
                            fontFamily: 'Delight',
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _showError ? _errorRed : Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _showError ? _errorRed : _primaryGreen,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: _errorRed, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: _errorRed, width: 2),
                          ),
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Error message alert box
                      if (_showError)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: _errorBackground,
                            border: Border.all(color: _errorRed, width: 1),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: _errorRed,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    fontFamily: 'Delight',
                                    fontSize: 14,
                                    color: Colors.red[900],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Continue button - Fixed at bottom
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
