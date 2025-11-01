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
  bool _bioExpanded = true;
  bool _jobExpanded = true;
  
  static const Color _primaryGreen = Color(0xFF2CA97B);

  // Real data from user selections
  Map<String, dynamic> _profileData = {};
  
  List<String> get _photoPaths {
    final photos = _profileData['photos'] as List<dynamic>?;
    if (photos == null) return [];
    return photos.cast<String>();
  }
  
  List<String> get _interests {
    final interests = _profileData['interests'] as List<dynamic>?;
    if (interests == null) return [];
    return interests.cast<String>();
  }
  
  List<String> get _lifestyles {
    final lifestyles = _profileData['lifestyles'] as List<dynamic>?;
    if (lifestyles == null) return [];
    return lifestyles.cast<String>();
  }
  
  String get _bio {
    return _profileData['bio'] as String? ?? '';
  }
  
  String get _height {
    final height = _profileData['height'] as Map<String, dynamic>?;
    if (height == null) return '';
    final feet = height['feet'] ?? 0;
    final inches = height['inches'] ?? 0;
    return '$feet ft $inches in';
  }
  
  String get _job {
    return _profileData['job'] as String? ?? '';
  }
  
  String get _industry {
    return _profileData['industry'] as String? ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener datos acumulados de arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic> && _profileData.isEmpty) {
      _profileData = Map<String, dynamic>.from(args);
    }
  }

  void _handleSaveAndContinue() {
    debugPrint('Saving profile and continuing...');
    
    // TODO: Save all profile data to backend
    
    // Navigate to profile ready page
    Navigator.pushNamed(
      context,
      '/profile-ready',
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
              if (_photoPaths.isNotEmpty)
                Row(
                  children: _photoPaths.take(3).map((path) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.file(
                              File(path),
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
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'No photos added',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Delight',
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Bio section
              if (_bio.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
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
                              _bioExpanded = !_bioExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Bio',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Delight',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _bioExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_bioExpanded)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _bio,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontFamily: 'Delight',
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              
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
                          children: [
                            ..._interests.map((item) {
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
                            }),
                            ..._lifestyles.map((item) {
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
                            }),
                          ],
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
                          child: _height.isNotEmpty
                              ? Container(
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
                                    _height,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Delight',
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Not specified',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: 'Delight',
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Job section
              if (_job.isNotEmpty || _industry.isNotEmpty)
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
                            _jobExpanded = !_jobExpanded;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Job & Industry',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Delight',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                _jobExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_jobExpanded)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_job.isNotEmpty) ...[
                                Text(
                                  'Job: $_job',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontFamily: 'Delight',
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (_industry.isNotEmpty)
                                Text(
                                  'Industry: $_industry',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontFamily: 'Delight',
                                  ),
                                ),
                            ],
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
