import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/di/injection.dart';
import '../../data/services/social_auth_service.dart';

/// Welcome / Auth Home Screen
/// 
/// Design Specifications:
/// - Background: Couple image with semi-transparent white overlay
/// - Logo: ForeverUs In Love (colored logo)
/// - Subtitle: "Start your journey with us"
/// - Primary buttons: Green #2CA97B with white background
/// - Social login: Facebook and Google icons (circular)
/// - Bottom text: "Already have one? Log In" with Terms link
/// 
/// Navigation:
/// - Continue with email → Registration flow
/// - Continue with phone → Registration flow
/// - Facebook/Google → OAuth flow
/// - Log In → Login screen
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _borderGreen = Color(0xFF2CA97B);
  
  // State variables
  bool _isLoadingGoogle = false;
  bool _isLoadingFacebook = false;
  
  late final SocialAuthService _socialAuthService;
  
  @override
  void initState() {
    super.initState();
    // Initialize social auth service (dependencies already configured in main.dart)
    _socialAuthService = GetIt.instance<SocialAuthService>();
  }

  /// Handle Google Sign In
  Future<void> _handleGoogleSignIn() async {
    if (_isLoadingGoogle) return;
    
    setState(() {
      _isLoadingGoogle = true;
    });

    try {
      // Use social auth service for Google sign in
      final result = await _socialAuthService.signInWithGoogle();

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Google login failed: ${failure.message}'),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
          }
        },
        (user) {
          if (mounted) {
            // Navigate to about you name page to complete profile
            Navigator.pushReplacementNamed(
              context,
              '/about-you-name',
              arguments: {
                'email': user.email,
                'phone': user.phone,
                'countryCode': null,
              },
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google login error: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGoogle = false;
        });
      }
    }
  }

  /// Handle Facebook Sign In
  Future<void> _handleFacebookSignIn() async {
    if (_isLoadingFacebook) return;
    
    setState(() {
      _isLoadingFacebook = true;
    });

    try {
      // Use social auth service for Facebook sign in
      final result = await _socialAuthService.signInWithFacebook();

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Facebook login failed: ${failure.message}'),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
          }
        },
        (user) {
          if (mounted) {
            // Navigate to about you name page to complete profile
            Navigator.pushReplacementNamed(
              context,
              '/about-you-name',
              arguments: {
                'email': user.email,
                'phone': user.phone,
                'countryCode': null,
              },
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facebook login error: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFacebook = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo/couple_background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to gradient if image fails
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink.shade100,
                        Colors.purple.shade100,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Content container with white rounded background - Centered but lower
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Logo - Super grande
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: Image.asset(
                      'assets/images/logo/Logo_For_Auth.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback text logo
                        return const Text(
                          'ForeverUs\nIN Love',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            fontFamily: 'Delight',
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Subtitle
                  const Text(
                    'Start your journey with us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      letterSpacing: 0.0,
                      fontFamily: 'Delight',
                    ),
                  ),
                  
                  const SizedBox(height: 34),
                  
                  // Continue with email button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to email registration
                        Navigator.pushNamed(context, '/register-email');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _primaryGreen,
                        side: const BorderSide(color: _borderGreen, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue with email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0.0,
                          fontFamily: 'Delight',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 26),
                  
                  // Continue with phone button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to phone registration
                        Navigator.pushNamed(context, '/register-phone');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _primaryGreen,
                        side: const BorderSide(color: _borderGreen, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue with phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0.0,
                          fontFamily: 'Delight',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 22),
                  
                  // Divider with "Or Log In with" text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or Log In with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: 0.0,
                            fontFamily: 'Delight',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 18),
                  
                  // Social login buttons (Facebook and Google)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Facebook button
                      _buildSocialButton(
                        onPressed: _isLoadingFacebook ? null : _handleFacebookSignIn,
                        isLoading: _isLoadingFacebook,
                        child: const Icon(
                          Icons.facebook,
                          color: Color(0xFF1877F2),
                          size: 20,
                        ),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      // Google button
                      _buildSocialButton(
                        onPressed: _isLoadingGoogle ? null : _handleGoogleSignIn,
                        isLoading: _isLoadingGoogle,
                        child: const Icon(
                          Icons.g_mobiledata,
                          color: Color(0xFF4285F4),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 18),
                  
                  // Already have account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have one? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          height: 1.0,
                          letterSpacing: 0.0,
                          fontFamily: 'Delight',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Log In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: 0.0,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            fontFamily: 'Delight',
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 18),
                  
                  // Terms and conditions text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          height: 1.0,
                          letterSpacing: 0.0,
                          fontFamily: 'Delight',
                        ),
                        children: [
                          const TextSpan(
                            text: 'By creating an account or signing you agree to our ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Delight',
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Navigate to terms and conditions
                                debugPrint('Terms and Conditions pressed');
                              },
                              child: const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.black,
                                  fontFamily: 'Delight',
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
            ),
          ),
        ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required Widget child,
    bool isLoading = false,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _borderGreen, width: 2),
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryGreen),
              ),
            )
          : child,
        padding: EdgeInsets.zero,
      ),
    );
  }
}