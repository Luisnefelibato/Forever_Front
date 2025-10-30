import 'package:flutter/material.dart';

/// Verification Prompt Screen
/// 
/// Design Specifications:
/// - Dark purple/gradient background (#190127)
/// - "skip" button in top right (white text)
/// - Key icon in purple/pink gradient circle
/// - Title: "Account created!" in green (#2CA97B)
/// - Heading: "What's next?" in white (bold)
/// - Description text about ID verification in white
/// - Green button: "Verify my identity"
/// - White link: "Remind me later"
/// - Progress bar at 80%
/// 
/// Navigation:
/// - Skip: Navigate to home/main screen
/// - Verify: Navigate to verification flow
/// - Remind later: Navigate to home/main screen
class VerificationPromptPage extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? birthDay;
  final int? birthMonth;
  final int? birthYear;
  final String? gender;
  final String? interests;
  final String? lookingFor;
  final String? location;
  
  const VerificationPromptPage({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
    this.gender,
    this.interests,
    this.lookingFor,
    this.location,
  });
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _darkPurple = Color(0xFF190127);
  static const Color _progressGray = Color(0xFFE0E0E0);
  
  void _skipVerification(BuildContext context) {
    // TODO: Navigate to main app screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Skipped verification - navigating to home'),
        backgroundColor: _primaryGreen,
      ),
    );
  }
  
  void _verifyIdentity(BuildContext context) {
    // Navigate to new verification intro page
    Navigator.pushNamed(context, '/verification/intro');
  }
  
  void _remindLater(BuildContext context) {
    // TODO: Navigate to main app screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Remind later - navigating to home'),
        backgroundColor: _primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkPurple,
      body: Stack(
        children: [
          // Background logo
          _buildBackgroundLogo(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  
                  // Progress bar and skip button
                  Row(
                    children: [
                      // Progress bar
                      Expanded(
                        child: _buildProgressBar(),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Skip button
                      TextButton(
                        onPressed: () => _skipVerification(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'skip',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Key icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF9C27B0),
                            const Color(0xFFE91E63),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.key,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Account created title
                  Center(
                    child: Text(
                      'Account created!',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _primaryGreen,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // What's next heading
                  const Center(
                    child: Text(
                      'What\'s next?',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description text
                  const Text(
                    'Every member on ForEverUs In Love goes through a quick ID check.\nThis helps us prevent fake accounts and create a trusted community where real connections can grow.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Verify my identity button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _verifyIdentity(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Verify my identity',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Remind me later link
                  Center(
                    child: TextButton(
                      onPressed: () => _remindLater(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Remind me later',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return SizedBox(
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: 0.8, // 80% progress
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
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