import 'package:flutter/material.dart';

/// Account Created Confirmation Screen
/// 
/// Design Specifications:
/// - Background: Dark purple (#190127)
/// - Logo as background decoration
/// - Centered content with star icon (golden yellow)
/// - Title: "Account created" in green (#2CA97B)
/// - Subtitle: "Your account has been successfully created, let's complete your profile." in white
/// - Auto-navigation to about you after 3 seconds
class AccountCreatedPage extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? countryCode;
  
  const AccountCreatedPage({
    super.key,
    this.email,
    this.phone,
    this.countryCode,
  });

  @override
  State<AccountCreatedPage> createState() => _AccountCreatedPageState();
}

class _AccountCreatedPageState extends State<AccountCreatedPage> {
  // Color constants
  static const Color _darkPurple = Color(0xFF190127);
  static const Color _successGreen = Color(0xFF2CA97B);
  static const Color _goldenYellow = Color(0xFFFFD700);
  static const Color _darkBrown = Color(0xFF8B4513);
  
  void _handleContinue() {
    Navigator.pushReplacementNamed(
      context,
      '/about-you-name',
      arguments: {
        'email': widget.email,
        'phone': widget.phone,
        'countryCode': widget.countryCode,
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkPurple, // Dark purple background
      body: Stack(
        children: [
          // Logo as background decoration (same as login)
          _buildBackgroundLogo(),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Star icon with shadow
                Stack(
                  children: [
                    // Shadow effect
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          'assets/images/icons/star.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.star,
                              size: 80,
                              color: _darkBrown.withOpacity(0.6),
                            );
                          },
                        ),
                      ),
                    ),
                    // Main star
                    Image.asset(
                      'assets/images/icons/star.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.star,
                          size: 80,
                          color: _goldenYellow,
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'Account created',
                  style: TextStyle(
                    fontFamily: 'Delight',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _successGreen,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Subtitle
                const Text(
                  'Time to know a little bit about you',
                  style: TextStyle(
                    fontFamily: 'Delight',
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: _successGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Delight',
                ),
              ),
            ),
          ),
        ),
      ),
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
