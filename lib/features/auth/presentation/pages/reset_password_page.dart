import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

/// Reset Password Screen
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Reset password" (Bold, Black)
/// - Subtitle: "Please enter new password in the input field below."
/// - Two password fields: "New Password" and "Confirm password"
/// - Password visibility toggle (eye icon)
/// - Validation box with dynamic states (gray/red/green)
/// - Button text changes based on validation state:
///   * "Reset password" - Initial/empty state
///   * "Restore" - Invalid password (doesn't meet criteria)
///   * "Create account" - Valid password (all criteria met)
/// 
/// Validation Rules:
/// 1. Password must contain both upper and lowercase letters
/// 2. Must include symbols like @ - _ * # and numbers
class ResetPasswordPage extends StatefulWidget {
  final String identifier;
  final String code;
  
  const ResetPasswordPage({
    super.key,
    required this.identifier,
    required this.code,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  // Validation state
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumbers = false;
  bool _hasSpecialChars = false;
  bool _passwordsMatch = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _infoBackgroundGray = Color(0xFFE0E0E0);
  static const Color _infoBackgroundGreen = Color(0xFFE8F5E9);
  
  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }
  
  @override
  void dispose() {
    _newPasswordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validatePassword);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _validatePassword() {
    final password = _newPasswordController.text;
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
  
  bool _canResetPassword() {
    return _isPasswordValid() && _passwordsMatch;
  }
  
  Color _getFieldBorderColor(bool isConfirmField) {
    if (isConfirmField) {
      // Confirm field turns red if doesn't match
      if (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) {
        return _errorRed;
      }
    } else {
      // Password field turns red if doesn't meet criteria
      if (_newPasswordController.text.isNotEmpty && !_isPasswordValid()) {
        return _errorRed;
      }
    }
    
    return Colors.black;
  }
  
  void _handleSubmit() async {
    if (!_canResetPassword()) {
      // Don't submit if password is invalid
      return;
    }
    
    // TEST MODE - Backend call commented for testing
    // TODO: Uncomment in production
    // try {
    //   final authRepository = GetIt.instance<AuthRepository>();
    //   final result = await authRepository.resetPasswordWithCode(
    //     identifier: widget.identifier,
    //     code: widget.code,
    //     newPassword: _newPasswordController.text,
    //   );
    //   result.fold(
    //     (failure) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Reset failed: ${failure.message}'),
    //           backgroundColor: _errorRed,
    //         ),
    //       );
    //     },
    //     (_) {
    //       Navigator.pushReplacementNamed(context, '/password-changed');
    //     },
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Reset error: $e'),
    //       backgroundColor: _errorRed,
    //     ),
    //   );
    // }
    
    // TEST MODE - Always allow access when password meets requirements
    Navigator.pushReplacementNamed(context, '/password-changed');
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
                      
                      const SizedBox(height: 32),
                      
                      // Title
                      const Text(
                        'Reset password',
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
                        'Please enter new password in the input field below.',
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
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
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
                              _obscureNewPassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
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
                      
                    ],
                  ),
                ),
              ),
            ),
            
            // Warning box - Above Reset password button
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
                  onPressed: _canResetPassword() ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canResetPassword() ? _primaryGreen : Colors.grey[400],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[400],
                    disabledForegroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Restore',
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
