import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/requests/login_request.dart';

/// Login / Email Screen
/// 
/// Design Specifications:
/// - Background: White with decorative colored shapes (turquoise, peach, purple)
/// - Back button: Top left circular with green border
/// - Title: "Log In Forever Us In Love"
/// - Subtitle: "With your ForEverUs In Love account"
/// - Input fields: Rounded with black border (red when error)
/// - Remember me: Green checkbox
/// - Forgot password: Black text, right aligned
/// - Login button: Green #2CA97B, full width, rounded
/// - Error state: Pink/red background alert with icon
/// 
/// Validations:
/// - Email/Phone: Required, valid format
/// - Password: Required, min 8 characters
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _showError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  
  late final AuthRepository _authRepository;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  
  @override
  void initState() {
    super.initState();
    // Initialize dependency injection
    configureDependencies();
    // Initialize auth repository
    _authRepository = GetIt.instance<AuthRepository>();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    setState(() {
      _showError = false;
      _isLoading = true;
    });
    
    if (_formKey.currentState!.validate()) {
      try {
        final login = _emailController.text.trim();
        final password = _passwordController.text;
        
        // Create login request
        final loginRequest = LoginRequest(
          login: login,
          password: password,
          remember: _rememberMe,
          deviceToken: null, // TODO: Add device token if needed
        );
        
        // Perform login
        final result = await _authRepository.login(
          login: login,
          password: password,
          remember: _rememberMe,
          deviceToken: null,
        );
        
        result.fold(
          (failure) {
            setState(() {
              _showError = true;
              _errorMessage = failure.message;
              _isLoading = false;
            });
          },
          (user) {
            setState(() {
              _isLoading = false;
            });
            
            // Navigate to home page on successful login
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        );
      } catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = 'An unexpected error occurred. Please try again.';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'Please fill in all required fields correctly.';
        _isLoading = false;
      });
    }
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address / Phone number is required';
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
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    // Check for password requirements (matching server validation)
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasNumber = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (!hasLowercase || !hasUppercase || !hasNumber || !hasSpecialChar) {
      return 'Password must contain: lowercase, uppercase, number, and special character';
    }
    
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft background color
      body: SafeArea(
        child: Stack(
          children: [
            // Logo as background decoration
            _buildBackgroundLogo(),
            
            // Main content
            Column(
              children: [
                // Scrollable content
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
                        onPressed: () {
                          // Always navigate to welcome page to avoid going back to forgot password flow
                          Navigator.pushReplacementNamed(context, '/welcome');
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    const Text(
                      'Log In Forever Us In\nLove',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'With your ForEverUs In Love account',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Email/Phone input
                    const Text(
                      'Email address / Phone number',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField
                    (
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      style: const TextStyle(
                        fontFamily: 'Delight',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Example@email.com or +1 555-123-4567',
                        hintStyle: TextStyle(
                          fontFamily: 'Delight',
                          color: Colors.grey[500],
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
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Password input
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      style: const TextStyle(
                        fontFamily: 'Delight',
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: '*********',
                        hintStyle: TextStyle(
                          fontFamily: 'Delight',
                          color: Colors.grey[500],
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
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
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
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Remember me and Forgot password
                    Row(
                      children: [
                        // Remember me checkbox
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _rememberMe ? _primaryGreen : Colors.white,
                            border: Border.all(
                              color: _primaryGreen,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: Colors.transparent,
                            checkColor: Colors.black,
                            side: BorderSide.none,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        // Forgot password link
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to forgot password
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Forgot password?',
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
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Error message (if validation fails)
                    if (_showError)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
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
                
                // Static Login button at bottom
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Log In',
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
                
                // "Create your account" link
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: GestureDetector(
                    onTap: _showCreateAccountDialog,
                    child: const Center(
                      child: Text(
                        'Create your account',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCreateAccountDialog() {
    showGeneralDialog(
      context: context,
      barrierLabel: 'create-account',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 320, maxWidth: 360),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(56),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Small logo on top (replaces heart icon)
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'assets/images/logo/Logo_Login.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Join our safe and genuine\nspace to meet real people',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 22,
                          height: 1.25,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/register-email');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.black,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create account with email',
                            style: TextStyle(
                              fontFamily: 'Delight',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/register-phone');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _primaryGreen, width: 2),
                            backgroundColor: Colors.white,
                            foregroundColor: _primaryGreen,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create account with phone',
                            style: TextStyle(
                              fontFamily: 'Delight',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _primaryGreen,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return Transform.scale(scale: 0.98 + 0.02 * curved.value, child: Opacity(opacity: curved.value, child: child));
      },
    );
  }
  
  Widget _buildBackgroundLogo() {
    return Positioned(
      top: -370,
      right: -400,
      child: Opacity(
        opacity: 0.15, // Slightly more visible
        child: Image.asset(
          'assets/images/logo/Logo_Login.png',
          width: 1000,
          height: 1000,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}