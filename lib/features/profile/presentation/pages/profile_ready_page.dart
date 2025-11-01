import 'package:flutter/material.dart';

/// Profile Ready Confirmation Screen
/// 
/// Design Specifications:
/// - Background: Dark purple (#190127)
/// - Logo as background decoration
/// - Centered content with star icon (golden yellow)
/// - Title: "Your Profile is ready!" in green (#2CA97B)
/// - Subtitle: "You've shared what makes you unique." in white
/// - Continue button: Green button at bottom
class ProfileReadyPage extends StatefulWidget {
  const ProfileReadyPage({super.key});

  @override
  State<ProfileReadyPage> createState() => _ProfileReadyPageState();
}

class _ProfileReadyPageState extends State<ProfileReadyPage> {
  // Color constants
  static const Color _darkPurple = Color(0xFF190127);
  static const Color _successGreen = Color(0xFF2CA97B);
  static const Color _goldenYellow = Color(0xFFFFD700);
  static const Color _darkBrown = Color(0xFF8B4513);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkPurple, // Dark purple background
      body: Stack(
        children: [
          // Logo as background decoration (same as login)
          _buildBackgroundLogo(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Star icon with shadow
                  Stack(
                    children: [
                      // Shadow effect
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Icon(
                          Icons.star,
                          size: 80,
                          color: _darkBrown.withOpacity(0.6),
                        ),
                      ),
                      // Main star
                      Icon(
                        Icons.star,
                        size: 80,
                        color: _goldenYellow,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'Your Profile is ready!',
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
                    'You\'ve shared what makes you unique.',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to home
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundLogo() {
    return Positioned(
      top: -370,
      right: -400,
      child: Opacity(
        opacity: 0.15,
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

