import 'package:flutter/material.dart';

/// About You - Gender Selection Screen
/// 
/// Design Specifications:
/// - Back button at top left (circular with green border)
/// - Progress bar showing ~40% completion
/// - Title: "How do you identify yourself?" (Bold, large, black)
/// - Subtitle: "Choose the option that best represents you..."
/// - Three radio options: Woman, Man, No binary
/// - Rounded rectangles with border radius 28px
/// - Selected state: Green background (#2CA97B) with black filled circle on right
/// - Unselected state: White background with black border and empty circle on right
/// - Error state: "Required to select" message in red below options
/// - Green FAB with arrow icon at bottom right
/// 
/// Validation:
/// - One option must be selected before proceeding
/// - Red error message appears if trying to proceed without selection
class AboutYouGenderPage extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? birthDay;
  final int? birthMonth;
  final int? birthYear;
  
  const AboutYouGenderPage({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
  });

  @override
  State<AboutYouGenderPage> createState() => _AboutYouGenderPageState();
}

class _AboutYouGenderPageState extends State<AboutYouGenderPage> {
  String? _selectedGender;
  bool _showError = false;
  bool _hasAttemptedSubmit = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  static const Color _progressGray = Color(0xFFE0E0E0);
  static const Color _disabledGray = Color(0xFF9E9E9E);
  
  final List<String> _genderOptions = [
    'Female',
    'Male',
    'Non binary',
  ];
  
  bool get _isGenderSelected => _selectedGender != null;
  
  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      if (_hasAttemptedSubmit) {
        _showError = false;
      }
    });
  }
  
  void _validateAndContinue() {
    setState(() {
      _hasAttemptedSubmit = true;
      _showError = _selectedGender == null;
    });
    
    if (!_showError) {
      // Navigate to next screen (interests)
      Navigator.pushNamed(
        context,
        '/about-you-interests',
        arguments: {
          'firstName': widget.firstName,
          'lastName': widget.lastName,
          'email': widget.email,
          'phone': widget.phone,
          'countryCode': widget.countryCode,
          'birthDay': widget.birthDay,
          'birthMonth': widget.birthMonth,
          'birthYear': widget.birthYear,
          'gender': _selectedGender,
        },
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Back button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _primaryGreen, width: 2),
                ),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/icons/back.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.arrow_back, color: _primaryGreen, size: 24);
                    },
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Progress bar
              _buildProgressBar(),
              
              const SizedBox(height: 16),
              
              // Step indicator
              Text(
                'Step 3/3 - Basic Info',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  color: _primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'How do you identify yourself?',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              const Text(
                'Choose the option that best represents you. This helps us create a respectful and inclusive space.',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Gender options
              ..._genderOptions.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildRadioOption(option),
              )),
              
              // Error message
              if (_showError) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _errorBackground,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: _errorRed,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/warning.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Required to select',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: _errorRed,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
            ],
          ),
        ),
      ),
      
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _isGenderSelected ? _validateAndContinue : null,
        backgroundColor: _isGenderSelected ? _primaryGreen : _disabledGray,
        child: _isGenderSelected
            ? Image.asset(
                'assets/images/icons/next_black.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.arrow_forward,
                    color: _primaryGreen,
                    size: 28,
                  );
                },
              )
            : Image.asset(
                'assets/images/icons/next_white.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.arrow_forward,
                    color: _progressGray,
                    size: 28,
                  );
                },
              ),
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return SizedBox(
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: 0.4, // 40% progress
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
        ),
      ),
    );
  }
  
  Widget _buildRadioOption(String option) {
    final bool isSelected = _selectedGender == option;
    
    return GestureDetector(
      onTap: () => _selectGender(option),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? _primaryGreen : Colors.black,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Option text
            Text(
              option,
              style: TextStyle(
                fontFamily: 'Delight',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
