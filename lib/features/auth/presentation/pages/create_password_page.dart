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
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumbers = false;
  bool _hasSpecialChars = false;
  bool _passwordsMatch = false;
  bool _agreeToTerms = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _infoBackgroundGray = Color(0xFFE0E0E0);
  static const Color _infoBackgroundGreen = Color(0xFFE8F5E9);
  
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
      // Check minimum length (8 characters) and maximum length (25 characters)
      _hasMinLength = password.length >= 8 && password.length <= 25;
      
      // Check for uppercase letters
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      
      // Check for lowercase letters
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      
      // Check for numbers
      _hasNumbers = password.contains(RegExp(r'[0-9]'));
      
      // Check for special characters (@ - _ * #)
      _hasSpecialChars = password.contains(RegExp(r'[@\-_*#]'));
      
      // Check if passwords match
      _passwordsMatch = password.isNotEmpty && 
                        confirm.isNotEmpty && 
                        password == confirm;
    });
  }
  
  bool _isPasswordValid() {
    return _hasMinLength && 
           _hasUppercase && 
           _hasLowercase && 
           _hasNumbers && 
           _hasSpecialChars;
  }
  
  bool _canCreateAccount() {
    return _isPasswordValid() && _passwordsMatch && _agreeToTerms;
  }
  
  Color _getFieldBorderColor(bool isConfirmField) {
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
                        'Step 1/3 - Account settings',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: _primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title
                      const Text(
                        'Create Password',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      const Text(
                        'Please enter a password in the input field below.',
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
                        maxLength: 25,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '*******',
                          counterText: '', // Hide character counter
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
                        maxLength: 25,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '*******',
                          counterText: '', // Hide character counter
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
                      
                      // Terms & Privacy Policy checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Checkbox
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _agreeToTerms ? _primaryGreen : Colors.white,
                              border: Border.all(
                                color: _primaryGreen,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: Colors.transparent,
                              checkColor: Colors.black,
                              side: BorderSide.none,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Delight',
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO: Navigate to Terms & Privacy Policy page
                                      },
                                      child: const Text(
                                        'Terms & Privacy Policy',
                                        style: TextStyle(
                                          fontFamily: 'Delight',
                                          fontSize: 14,
                                          color: Colors.black,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Warning box - Above Create account button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _isPasswordValid() ? _infoBackgroundGreen : _infoBackgroundGray,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: _isPasswordValid() ? _primaryGreen : Colors.grey[600]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      _isPasswordValid() 
                        ? 'assets/images/icons/check.png'
                        : 'assets/images/icons/exclamation.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _isPasswordValid() ? Icons.check_circle : Icons.info_outline,
                          color: _isPasswordValid() ? _primaryGreen : Colors.grey[700],
                          size: 24,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ensure your password has at least 8 characters, includes both uppercase and lowercase letters, and contains symbols like @ - _ * # and numbers.',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
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
                    backgroundColor: _canCreateAccount() ? _primaryGreen : Colors.grey[400],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[400],
                    disabledForegroundColor: Colors.grey[600],
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
