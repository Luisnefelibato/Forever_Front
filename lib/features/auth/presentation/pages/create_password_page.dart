import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import 'account_created_page.dart';

/// Create Password Screen
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Let's get started" (Bold, Black)
/// - Subtitle: "Create your account to join ForEverUs In Love"
/// - Two password fields: "Password" and "Confirm password"
/// - Password visibility toggle (eye icon)
/// - Validation box with dynamic states (gray/red/green)
/// - Button text: "Create account" when valid
/// - Info message about verification
/// 
/// Validation Rules:
/// 1. Password must contain both upper and lowercase letters
/// 2. Must include symbols like @ - _ * # and numbers
/// 3. Passwords must match
class CreatePasswordPage extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? registrationType; // 'email' or 'phone'
  
  const CreatePasswordPage({
    super.key,
    this.email,
    this.phone,
    this.countryCode,
    this.registrationType,
  });

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Validation state
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasSymbolsOrNumbers = false;
  bool _passwordsMatch = false;
  bool _hasStartedTyping = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _lightRed = Color(0xFFFFEBEE);
  static const Color _lightGray = Color(0xFFEEEEEE);
  static const Color _infoBackground = Color(0xFFE0E0E0);
  
  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }
  
  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validatePassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _validatePassword() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    
    setState(() {
      _hasStartedTyping = password.isNotEmpty;
      
      // Rule 1: Check for uppercase and lowercase letters
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      
      // Rule 2: Check for symbols and numbers
      _hasSymbolsOrNumbers = password.contains(RegExp(r'[@\-_*#0-9]'));
      
      // Check if passwords match
      _passwordsMatch = password.isNotEmpty && 
                        confirm.isNotEmpty && 
                        password == confirm;
    });
  }
  
  bool _isPasswordValid() {
    return _hasUppercase && 
           _hasLowercase && 
           _hasSymbolsOrNumbers;
  }
  
  bool _canCreateAccount() {
    return _isPasswordValid() && _passwordsMatch;
  }
  
  Color _getValidationBoxColor() {
    if (!_hasStartedTyping) {
      return _lightGray;
    } else if (_isPasswordValid()) {
      return _lightGreen;
    } else {
      return _lightRed;
    }
  }
  
  Color _getValidationBorderColor() {
    if (!_hasStartedTyping) {
      return Colors.grey.shade300;
    } else if (_isPasswordValid()) {
      return _successGreen;
    } else {
      return _errorRed;
    }
  }
  
  Widget _getValidationIcon() {
    if (!_hasStartedTyping) {
      return Icon(
        Icons.error_outline,
        color: Colors.grey.shade600,
        size: 32,
      );
    } else if (_isPasswordValid()) {
      return Icon(
        Icons.check_circle,
        color: _successGreen,
        size: 32,
      );
    } else {
      return Icon(
        Icons.error_outline,
        color: _errorRed,
        size: 32,
      );
    }
  }
  
  Color _getFieldBorderColor(bool isConfirmField) {
    if (!_hasStartedTyping) {
      return Colors.black;
    }
    
    if (isConfirmField) {
      // Confirm field turns red if doesn't match
      if (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) {
        return _errorRed;
      }
    } else {
      // Password field turns red if doesn't meet criteria
      if (_passwordController.text.isNotEmpty && !_isPasswordValid()) {
        return _errorRed;
      }
    }
    
    return Colors.black;
  }
  
  Future<void> _handleSubmit() async {
    if (!_canCreateAccount()) {
      // Don't submit if password is invalid
      return;
    }
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2CA97B)),
          ),
        ),
      );
      
      // Get auth repository
      final authRepository = GetIt.instance<AuthRepository>();
      
      // Register user with real API
      final result = await authRepository.register(
        email: widget.email,
        phone: widget.phone,
        password: _passwordController.text,
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Handle result
      result.fold(
        (failure) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error creating account: ${failure.message}'),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
          }
        },
        (user) {
          // Registration successful, navigate to email verification
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              '/email-verification',
              arguments: {
                'email': widget.email,
                'firstName': 'User', // TODO: Get from user input
                'lastName': 'Name',  // TODO: Get from user input
                'dateOfBirth': '1990-01-01', // TODO: Get from user input
                'password': _passwordController.text,
              },
            );
          }
        },
      );
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating account: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
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
                        'Let\'s get started',
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
                        'Create your account to join ForEverUs In Love',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Password label
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _getFieldBorderColor(false),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _getFieldBorderColor(false),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Confirm password label
                      const Text(
                        'Confirm password',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Confirm password field
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _getFieldBorderColor(true),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: _getFieldBorderColor(true),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Validation box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _getValidationBoxColor(),
                          border: Border.all(
                            color: _getValidationBorderColor(),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: _getValidationIcon(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Delight',
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        height: 1.5,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: '1. Ensure the password contain both upper and lowercase letter\n',
                                        ),
                                        TextSpan(
                                          text: '2. Include symbols like ',
                                        ),
                                        TextSpan(
                                          text: '@ - _ * #',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and numbers',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Info message box
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _infoBackground,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'We require it only to verify your account, it will never be displayed on your profile.',
                                style: TextStyle(
                                  fontFamily: 'Delight',
                                  fontSize: 14,
                                  color: Colors.grey[800],
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
            
            // Button - Fixed at bottom
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canCreateAccount() ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create account',
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
