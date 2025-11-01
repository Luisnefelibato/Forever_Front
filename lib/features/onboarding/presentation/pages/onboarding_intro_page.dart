import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/// Centralized Onboarding Intro Page with smooth image transitions
/// 
/// Features:
/// - PageView for smooth swiping between images
/// - Precached images to prevent gray screens
/// - Auto-advance timer (3 seconds per page)
/// - Skip button that navigates to permissions or login
/// - Smooth transitions between pages
class OnboardingIntroPage extends StatefulWidget {
  const OnboardingIntroPage({super.key});

  @override
  State<OnboardingIntroPage> createState() => _OnboardingIntroPageState();
}

class _OnboardingIntroPageState extends State<OnboardingIntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;
  bool _imagesPrecached = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  
  // Intro pages data
  final List<IntroPageData> _introPages = [
    IntroPageData(
      imagePath: 'assets/images/logo/intro_page_1.png',
      title: 'Where meaningful\nconnections begin\nagain.',
    ),
    IntroPageData(
      imagePath: 'assets/images/logo/intro_page_2.png',
      title: 'Verified profiles.\nFeel safe being\nyourself.',
    ),
    IntroPageData(
      imagePath: 'assets/images/logo/intro_page_3.png',
      title: 'However You Identify\nYourself, you\'re\nAlways Welcome Here.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _precacheImages();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Precaching images to prevent gray screens during transitions
  Future<void> _precacheImages() async {
    try {
      final List<Future<void>> futures = [];
      for (var page in _introPages) {
        futures.add(precacheImage(AssetImage(page.imagePath), context));
      }
      await Future.wait(futures);
      
      if (mounted) {
        setState(() {
          _imagesPrecached = true;
        });
      }
    } catch (e) {
      // If precaching fails, continue anyway
      if (mounted) {
        setState(() {
          _imagesPrecached = true;
        });
      }
    }
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentPage < _introPages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _navigateToNext();
        }
      }
    });
  }

  void _onPageChanged(int index) {
    if (_currentPage != index) {
      setState(() {
        _currentPage = index;
      });
      // Reiniciar el timer cuando cambia la página (ya sea manualmente o automáticamente)
      _startAutoAdvance();
    }
  }

  Future<void> _navigateToNext() async {
    _autoAdvanceTimer?.cancel();
    
    // Check if permissions were already requested
    final prefs = await SharedPreferences.getInstance();
    final permissionsRequested = prefs.getBool('permissions_requested') ?? false;
    
    if (mounted) {
      if (permissionsRequested) {
        Navigator.pushReplacementNamed(context, '/welcome');
      } else {
        Navigator.pushReplacementNamed(context, '/permissions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with intro images
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _introPages.length,
            physics: const ClampingScrollPhysics(),
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return _buildIntroPage(_introPages[index]);
            },
          ),

          // Skip button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _navigateToNext,
                  child: const Text(
                    'skip.',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Page indicator dots at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _introPages.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildDot(isActive: index == _currentPage),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(IntroPageData pageData) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          // Background image with precached image - using Image.asset directly for better control
          Positioned.fill(
            child: Image.asset(
              pageData.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  return child;
                }
                // Show previous page content while loading
                return AnimatedOpacity(
                  opacity: frame == null ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
          ),
        // Gradient overlay
        Container(
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

        // Content
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Title - positioned above the dots
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  pageData.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Delight',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        shape: isActive ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isActive ? BorderRadius.circular(4) : null,
        color: isActive
            ? _primaryGreen
            : Colors.white.withOpacity(0.4),
      ),
    );
  }
}

/// Data class for intro pages
class IntroPageData {
  final String imagePath;
  final String title;

  IntroPageData({
    required this.imagePath,
    required this.title,
  });
}

