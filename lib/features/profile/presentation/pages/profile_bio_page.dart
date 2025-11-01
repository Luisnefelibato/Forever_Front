import 'package:flutter/material.dart';

/// Profile Bio Page
/// 
/// Permite al usuario escribir una breve introducción personal.
/// Máximo 300 caracteres.
/// 
/// Design specs:
/// - Progress bar: ~15% (verde #2CA97B)
/// - Back button: Circular verde con flecha
/// - Skip button: Top right
/// - Title: "Share a short introduction."
/// - Subtitle: "Let others know the person behind the smile."
/// - Input: Text area grande con placeholder
/// - Character counter: 0/300
/// - Continue button: Verde, sticky bottom
class ProfileBioPage extends StatefulWidget {
  const ProfileBioPage({super.key});

  @override
  State<ProfileBioPage> createState() => _ProfileBioPageState();
}

class _ProfileBioPageState extends State<ProfileBioPage> {
  final TextEditingController _bioController = TextEditingController();
  static const int _maxCharacters = 300;
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _progressGray = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _bioController.addListener(() {
      setState(() {}); // Update character count
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final bioData = {
      'bio': _bioController.text.trim(),
    };
    
    // Navegar a intereses pasando los datos acumulados
    Navigator.pushNamed(
      context,
      '/profile-interests',
      arguments: bioData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = _bioController.text.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress, back and skip
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Back and Skip row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      // Skip button
                      TextButton(
                        onPressed: _handleContinue,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progress bar (~15%)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: 0.15,
                      backgroundColor: _progressGray,
                      valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Share a short introduction.',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'Let others know the person behind the smile.',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bio input field (large text area)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: TextField(
                        controller: _bioController,
                        maxLength: _maxCharacters,
                        maxLines: 6,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write a little bit about you...',
                          hintStyle: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 16,
                            color: Colors.grey[400],
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                          counterText: '', // Hide default counter
                          contentPadding: EdgeInsets.zero,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Character counter
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$characterCount/$_maxCharacters',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Helper text
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Write something that feels natural, just like how you\'d introduce yourself in person.',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue button - Sticky bottom
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
