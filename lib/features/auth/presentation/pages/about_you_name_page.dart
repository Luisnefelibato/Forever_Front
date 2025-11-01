import 'package:flutter/material.dart';

/// About You - Name Screen
/// 
/// Design Specifications:
/// - Progress bar at top showing ~20% completion with green #2CA97B
/// - Title: "What's your name?" (Bold, large, black)
/// - Subtitle: "It's how others will recognize you"
/// - Two input fields: "First name" and "Last name"
/// - Rounded border inputs with placeholder text in gray
/// - Error state: Red border with "Complete field to continue" message
/// - Green FAB with arrow icon at bottom right
/// - Background: White
/// 
/// Validation:
/// - Both fields required before proceeding
/// - Text turns black when user types
/// - Red error message appears below empty field when trying to proceed
class AboutYouNamePage extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? countryCode;
  
  const AboutYouNamePage({
    super.key,
    this.email,
    this.phone,
    this.countryCode,
  });

  @override
  State<AboutYouNamePage> createState() => _AboutYouNamePageState();
}

class _AboutYouNamePageState extends State<AboutYouNamePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  bool _showFirstNameError = false;
  bool _showLastNameError = false;
  bool _hasAttemptedSubmit = false;
  
  // Color constants matching design
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _progressGray = Color(0xFFE0E0E0);
  static const Color _placeholderGray = Color(0xFF9E9E9E);
  static const Color _disabledGray = Color(0xFF9E9E9E);
  
  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
  }
  
  @override
  void dispose() {
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
  
  bool get _areFieldsValid {
    return _firstNameController.text.trim().isNotEmpty &&
           _lastNameController.text.trim().isNotEmpty;
  }
  
  void _onFieldChanged() {
    setState(() {
      if (_hasAttemptedSubmit) {
        _showFirstNameError = _firstNameController.text.trim().isEmpty;
        _showLastNameError = _lastNameController.text.trim().isEmpty;
      }
    });
  }
  
  void _validateAndContinue() {
    setState(() {
      _hasAttemptedSubmit = true;
      _showFirstNameError = _firstNameController.text.trim().isEmpty;
      _showLastNameError = _lastNameController.text.trim().isEmpty;
    });
    
    if (!_showFirstNameError && !_showLastNameError) {
      // Navigate to next screen (birthdate)
      Navigator.pushNamed(
        context,
        '/about-you-birthdate',
        arguments: {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': widget.email,
          'phone': widget.phone,
          'countryCode': widget.countryCode,
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
              const SizedBox(height: 48),
              
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
                'What\'s your name?',
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
                'It\'s how others will recognize you.',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // First name input
              _buildInputField(
                label: 'First name',
                placeholder: 'Type your first name',
                controller: _firstNameController,
                showError: _showFirstNameError,
              ),
              
              const SizedBox(height: 24),
              
              // Last name input
              _buildInputField(
                label: 'Last name',
                placeholder: 'Type your last name',
                controller: _lastNameController,
                showError: _showLastNameError,
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
      
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _areFieldsValid ? _validateAndContinue : null,
        backgroundColor: _areFieldsValid ? _primaryGreen : _disabledGray,
        shape: const CircleBorder(),
        child: _areFieldsValid
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
          value: 0.2, // 20% progress (step 1 of ~5)
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required bool showError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Delight',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Input field
        TextField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Delight',
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontFamily: 'Delight',
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: showError ? _errorRed : Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: showError ? _errorRed : Colors.black,
                width: 2,
              ),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        
        // Error message
        if (showError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'Complete field to continue',
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
      ],
    );
  }
}
