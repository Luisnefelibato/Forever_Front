import 'package:flutter/material.dart';

/// Password Changed Confirmation Screen
/// 
/// Design Specifications:
/// - Background: Dark purple (#190127)
/// - Decorative abstract shapes in top right corner
/// - Centered content with star icon (golden yellow)
/// - Title: "Password changed" in green (#2CA97B)
/// - Subtitle: "Your password has been successfully reset, you can now log in again." in white
/// - Auto-navigation to login after 3 seconds
class PasswordChangedPage extends StatefulWidget {
  const PasswordChangedPage({super.key});

  @override
  State<PasswordChangedPage> createState() => _PasswordChangedPageState();
}

class _PasswordChangedPageState extends State<PasswordChangedPage> {
  // Color constants
  static const Color _darkPurple = Color(0xFF190127);
  static const Color _successGreen = Color(0xFF2CA97B);
  static const Color _goldenYellow = Color(0xFFFFD700);
  static const Color _darkBrown = Color(0xFF8B4513);
  
  @override
  void initState() {
    super.initState();
    // Auto-navigate to login after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
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
                  'Password changed',
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
                  'Your password has been\nsuccessfully reset, you\ncan now log in again.',
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
