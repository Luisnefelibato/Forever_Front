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
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                    width: 200,
                    height: 80,
                    child: Image.asset(
                      'assets/images/logo/Logo_For_Auth.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback text logo
                        return const Text(
                          'ForEverUs\nIn Love',
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
                  
                  const SizedBox(height: 4),
                  
                  // Subtitle
                  const Text(
                    'Start your journey with us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: 0.0,
                      fontFamily: 'Delight',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Continue with your account button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                          side: const BorderSide(color: _borderGreen, width: 2),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue with your account',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          letterSpacing: 0.0,
                          fontFamily: 'Delight',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 14),
                  
                  // Divider with "Or Sign up with" text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Or Sign up with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
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
                  
                  const SizedBox(height: 12),
                  
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
                      
                      const SizedBox(width: 16),
                      
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
                  
                  const SizedBox(height: 12),
                  
                  // Terms and conditions text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
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