import 'package:flutter/material.dart';

/// Profile Job Page
/// 
/// Allows users to input their job title and industry.
class ProfileJobPage extends StatefulWidget {
  const ProfileJobPage({super.key});

  @override
  State<ProfileJobPage> createState() => _ProfileJobPageState();
}

class _ProfileJobPageState extends State<ProfileJobPage> {
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  
  static const Color _primaryGreen = Color(0xFF2CA97B);

  void _handleSkip() {
    Navigator.pushNamed(context, '/profile-review');
  }

  void _handleNext() {
    final jobData = {
      'job': _jobController.text.trim(),
      'industry': _industryController.text.trim(),
    };
    
    debugPrint('Job: ${jobData['job']}, Industry: ${jobData['industry']}');
    
    // Navigate to review page
    Navigator.pushNamed(
      context,
      '/profile-review',
      arguments: jobData,
    );
  }

  @override
  void dispose() {
    _jobController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _primaryGreen,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2CA97B),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _handleSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Delight',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'What do you do for\nliving?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Delight',
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your job.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Delight',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Form fields
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job field
                  const Text(
                    'Job',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Delight',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _jobController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Delight',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your job title',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontFamily: 'Delight',
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(
                          color: _primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Industry field
                  const Text(
                    'Industry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Delight',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _industryController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Delight',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your job title',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontFamily: 'Delight',
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(
                          color: _primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Next button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Delight',
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
