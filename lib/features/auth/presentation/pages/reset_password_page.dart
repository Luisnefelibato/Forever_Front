import 'package:flutter/material.dart';

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
  final String? resetToken;
  
  const ResetPasswordPage({
    super.key,
    this.resetToken,
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
  
  String _getButtonText() {
    if (!_hasStartedTyping) {
      return 'Reset password';
    } else if (_canCreateAccount()) {
      return 'Create account';
    } else {
      return 'Restore';
    }
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
  
  Color _getValidationIconColor() {
    if (!_hasStartedTyping) {
      return Colors.grey.shade600;
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
      // New password field turns red if doesn't meet criteria
      if (_newPasswordController.text.isNotEmpty && !_isPasswordValid()) {
        return _errorRed;
      }
    }
    
    return Colors.black;
  }
  
  void _handleSubmit() {
    if (!_canCreateAccount()) {
      // Don't submit if password is invalid
      return;
    }
    
    // TODO: Implement actual API call to reset password
    // final response = await dio.post('/api/auth/reset-password', data: {
    //   'resetToken': widget.resetToken,
    //   'newPassword': _newPasswordController.text,
    // });
    
    // Navigate to password changed confirmation page
    Navigator.pushReplacementNamed(
      context,
      '/password-changed',
    );
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
                      
                      // New Password label
                      const Text(
                        'New Password',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // New Password field
                      TextField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
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
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _getButtonText(),
                    style: const TextStyle(
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
