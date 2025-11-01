import 'package:flutter/material.dart';

/// Register with Email - Step 1
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Let's get started" (Bold, Black)
/// - Subtitle: "Create your account to join ForEverUs In Love"
/// - Email input field: Rounded with black border (red when error)
/// - Info message: Gray background with info icon
/// - Create account button: Green #2CA97B, full width, positioned at bottom
/// - Error state: Pink/red background alert with icon
/// 
/// Flow:
/// - User enters email
/// - Validates email format
/// - On success: Navigate to create password screen
/// 
/// Validations:
/// - Email: Required, valid format, max 100 chars
class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({super.key});

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _showError = false;
  String _errorMessage = '';
  bool _isEmailComplete = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  static const Color _infoBackgroundGray = Color(0xFFE0E0E0);
  static const Color _infoBackgroundGreen = Color(0xFFE8F5E9);
  
  @override
  void initState() {
    super.initState();
    // Listen to email changes to check if email has valid domain extension
    _emailController.addListener(_checkEmailCompletion);
  }
  
  @override
  void dispose() {
    _emailController.removeListener(_checkEmailCompletion);
    _emailController.dispose();
    super.dispose();
  }
  
  void _checkEmailCompletion() {
    final email = _emailController.text.trim();
    // Check if email has a valid domain extension (.com, .net, .org, etc.)
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isComplete = email.isNotEmpty && emailRegex.hasMatch(email) && email.length <= 100;
    if (_isEmailComplete != isComplete) {
      setState(() {
        _isEmailComplete = isComplete;
      });
    }
  }
  
  void _handleContinue() {
    setState(() {
      _showError = false;
    });
    
    // Check if field is empty
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'The mobile number, email and/or password are not valid.';
      });
      return;
    }
    
    // Validate format
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      
      // Navigate to create password screen with email
      Navigator.pushNamed(
        context,
        '/create-password',
        arguments: {'email': email, 'registrationType': 'email'},
      );
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'The mobile number, email and/or password are not valid.';
      });
    }
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    
    // Check if it's a valid email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    if (value.length > 100) {
      return 'Email cannot exceed 100 characters';
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
                      
                      // Email address label
                      const Text(
                        'Email address',
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
                          // Update email completion status
                          _checkEmailCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Example@email.com',
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
                              width: 1.5,
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
                            borderSide: const BorderSide(color: _errorRed, width: 1.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: const BorderSide(color: _errorRed, width: 2),
                          ),
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Error message alert box (if validation fails)
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
                      
                      if (_showError) const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Info message box - Above Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _isEmailComplete ? _infoBackgroundGreen : _infoBackgroundGray,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: _isEmailComplete ? _primaryGreen : Colors.grey[600]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      _isEmailComplete 
                        ? 'assets/images/icons/check.png'
                        : 'assets/images/icons/exclamation.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _isEmailComplete ? Icons.check_circle : Icons.info_outline,
                          color: _isEmailComplete ? _primaryGreen : Colors.grey[700],
                          size: 24,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'We require it only to verify your account, it will never be displayed on your profile.',
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
            
            // Create account button - Fixed at bottom
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isEmailComplete ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEmailComplete ? _primaryGreen : Colors.grey[400],
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
