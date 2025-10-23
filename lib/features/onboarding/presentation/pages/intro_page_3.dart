import 'package:flutter/material.dart';
import 'dart:async';

/// Onboarding Intro 3: "However You Identify Yourself, you're Always Welcome Here"
/// 
/// Design Notes:
/// - Background: Image with overlay (dating couple photo)
/// - Skip button: Top right, bold font
/// - Title typography: Bold, 32px, center aligned
/// - Page indicator: 3 dots at bottom (third active)
/// 
/// Colors to be updated with final design:
/// - Background overlay: Semi-transparent gradient
/// - Text color: White (#FFFFFF) - TODO: Update with design
/// - Active dot: Primary color - TODO: Update with design
/// - Inactive dot: Gray/White transparent - TODO: Update with design
class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/permissions');
      }
    });
  }

  void _navigateToNext() {
    _timer.cancel();
    Navigator.pushReplacementNamed(context, '/permissions');
  }

  void _navigateToPrevious() {
    _timer.cancel();
    Navigator.pushReplacementNamed(context, '/onboarding-intro-2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[500], // Fallback background
              image: const DecorationImage(
                image: AssetImage('assets/images/logo/intro_page_3.png'),
                fit: BoxFit.cover,
                onError: null,
              ),
            ),
            child: Container(
              // Gradient overlay for text readability
              // TODO: Update gradient colors with final design
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/permissions');
                      },
                      child: Text(
                        'skip',
                        style: TextStyle(
                          // TODO: Update with design font family
                          fontWeight: FontWeight.w700, // Bold (700)
                          fontSize: 16,
                          color: Colors.white, // TODO: Update with design color
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Main title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'However You Identify\nYourself, you\'re\nAlways Welcome Here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // TODO: Update font-family with Tipografia/Tipografia-1
                      fontWeight: FontWeight.w700, // Bold (700)
                      fontSize: 32, // Tamaños/32
                      height: 1.0, // line-height: 100%
                      letterSpacing: 0, // letter-spacing: 0%
                      color: Colors.white, // TODO: Update with design color
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(isActive: false),
                    const SizedBox(width: 8),
                    _buildDot(isActive: false),
                    const SizedBox(width: 8),
                    _buildDot(isActive: true),
                  ],
                ),

                const SizedBox(height: 40),

                // Navigation area with swipe detection
                GestureDetector(
                  onTap: _navigateToNext,
                  onPanEnd: (details) {
                    // Swipe left to go to next page (permissions)
                    if (details.velocity.pixelsPerSecond.dx < -500) {
                      _navigateToNext();
                    }
                    // Swipe right to go to previous page
                    else if (details.velocity.pixelsPerSecond.dx > 500) {
                      _navigateToPrevious();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // TODO: Update colors with final design
        color: isActive
            ? Colors.white // Active dot - TODO: Update with primary color
            : Colors.white.withOpacity(0.4), // Inactive dot
      ),
    );
  }
}
