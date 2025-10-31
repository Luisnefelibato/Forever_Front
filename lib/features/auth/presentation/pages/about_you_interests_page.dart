import 'package:flutter/material.dart';

/// About You - Meeting Interests Screen
/// 
/// Design Specifications:
/// - Back button at top left (circular with green border)
/// - Progress bar showing ~50% completion
/// - Title: "Would you like to meet..." (Bold, large, black)
/// - Subtitle: "Select who you're open to connecting with..."
/// - Four radio options: Woman, Man, No binary, All of them
/// - Rounded rectangles with border radius 28px
/// - Selected state: Green background (#2CA97B) with black filled circle on right
/// - Unselected state: White background with black border and empty circle on right
/// - Error state: "Required to select" message in red below options
/// - Green FAB with arrow icon at bottom right
/// 
/// Validation:
/// - One option must be selected before proceeding
/// - Red error message appears if trying to proceed without selection
class AboutYouInterestsPage extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? birthDay;
  final int? birthMonth;
  final int? birthYear;
  final String? gender;
  
  const AboutYouInterestsPage({
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
  });

  @override
  State<AboutYouInterestsPage> createState() => _AboutYouInterestsPageState();
}

class _AboutYouInterestsPageState extends State<AboutYouInterestsPage> {
  String? _selectedInterest;
  bool _showError = false;
  bool _hasAttemptedSubmit = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _progressGray = Color(0xFFE0E0E0);
  
  final List<String> _interestOptions = [
    'Woman',
    'Man',
    'Non binary',
    'All of them',
  ];
  
  void _selectInterest(String interest) {
    setState(() {
      _selectedInterest = interest;
      if (_hasAttemptedSubmit) {
        _showError = false;
      }
    });
  }
  
  void _validateAndContinue() {
    setState(() {
      _hasAttemptedSubmit = true;
      _showError = _selectedInterest == null;
    });
    
    if (!_showError) {
      // Navigate to next screen (looking for)
      Navigator.pushNamed(
        context,
        '/about-you-looking-for',
        arguments: {
          'firstName': widget.firstName,
          'lastName': widget.lastName,
          'email': widget.email,
          'phone': widget.phone,
          'countryCode': widget.countryCode,
          'birthDay': widget.birthDay,
          'birthMonth': widget.birthMonth,
          'birthYear': widget.birthYear,
          'gender': widget.gender,
          'interests': _selectedInterest,
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
              
              // Step indicator
              Text(
                'Step 3/3 - Account settings',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  color: _primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Back button
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _primaryGreen,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: _primaryGreen,
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Progress bar
              _buildProgressBar(),
              
              const SizedBox(height: 16),
              
              // Step indicator
              Text(
                'Step 3/3 - Account settings',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  color: _primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Title
              const Text(
                'Would you like to meet...',
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
                'Select who you\'re open to connecting with. You can always change this later',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Interest options
              ..._interestOptions.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildRadioOption(option),
              )),
              
              // Error message
              if (_showError) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
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
              
              const Spacer(),
            ],
          ),
        ),
      ),
      
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _validateAndContinue,
        backgroundColor: _primaryGreen,
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 28,
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
          value: 0.5, // 50% progress
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
        ),
      ),
    );
  }
  
  Widget _buildRadioOption(String option) {
    final bool isSelected = _selectedInterest == option;
    
    return GestureDetector(
      onTap: () => _selectInterest(option),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(28),
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
                color: isSelected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 14,
                        color: Colors.black,
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
