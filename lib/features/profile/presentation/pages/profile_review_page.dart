import 'dart:io';
import 'package:flutter/material.dart';

/// Profile Review Page
/// 
/// Final review page where users can see all their profile information
/// before saving and continuing to the app.
class ProfileReviewPage extends StatefulWidget {
  const ProfileReviewPage({super.key});

  @override
  State<ProfileReviewPage> createState() => _ProfileReviewPageState();
}

class _ProfileReviewPageState extends State<ProfileReviewPage> {
  bool _personalSnapshotExpanded = true;
  bool _yourHeightExpanded = true;
  
  static const Color _primaryGreen = Color(0xFF2CA97B);

  // Mock data - in real app, this would come from state management
  final List<String> _mockPhotoPaths = [
    'assets/images/onboarding/profile_intro_couple.jpg',
    'assets/images/onboarding/profile_intro_couple.jpg',
    'assets/images/onboarding/profile_intro_couple.jpg',
  ];

  final List<String> _mockSelectedItems = [
    'Painting',
    'Reading mystery novels',
    'Long walks in the park',
    'Bachelor\'s in Literature',
    'Relaxed schedule',
    'Part-time consulting',
    'I have kids',
    'Non-smoker',
  ];

  final String _mockHeight = '165 cm';

  void _handleSaveAndContinue() {
    debugPrint('Saving profile and continuing...');
    
    // TODO: Save all profile data to backend
    
    // Navigate to home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Here\'s what makes\nyou, you.',
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
                'Review your answers,\nYou can always edit them later.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Delight',
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Photos
              Row(
                children: _mockPhotoPaths.take(3).map((path) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey[500],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Personal snapshot section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _personalSnapshotExpanded = !_personalSnapshotExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Personal snapshot',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Delight',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              _personalSnapshotExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_personalSnapshotExpanded)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _mockSelectedItems.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: _primaryGreen,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: _primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Delight',
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Your height section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _yourHeightExpanded = !_yourHeightExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Your height',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Delight',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              _yourHeightExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_yourHeightExpanded)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _mockHeight,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Delight',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _handleSaveAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save and Continue',
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
}
