import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Register with Phone - Step 1
/// 
/// Design Specifications:
/// - Background: White (#FFFFFF)
/// - Back button: Top left circular with green border #2CA97B
/// - Title: "Let's get started" (Bold, Black)
/// - Subtitle: "Create your account to join ForEverUs In Love"
/// - Country code selector: Dropdown with +1 (USA only for now)
/// - Phone input field: Rounded with black border (red when error)
/// - Info message: Gray background with info icon
/// - Create account button: Green #2CA97B, full width, positioned at bottom
/// - Error state: Pink/red background alert with icon
/// 
/// Flow:
/// - User selects country code (currently only +1 USA)
/// - User enters phone number (10 digits)
/// - Validates phone format
/// - On success: Navigate to create password screen
/// 
/// Validations:
/// - Phone: Required, 10 digits, Colombian/US format
class RegisterPhonePage extends StatefulWidget {
  const RegisterPhonePage({super.key});

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  
  String _selectedCountryCode = '+1';
  String _selectedCountryFlag = '🇺🇸';
  String _selectedCountryName = 'United States';
  
  bool _showError = false;
  String _errorMessage = '';
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  static const Color _infoBackground = Color(0xFFE0E0E0);
  
  // Country codes list (can be expanded in the future)
  final List<Map<String, String>> _countries = [
    {'code': '+1', 'flag': '🇺🇸', 'name': 'United States'},
    {'code': '+1', 'flag': '🇨🇦', 'name': 'Canada'},
    {'code': '+52', 'flag': '🇲🇽', 'name': 'Mexico'},
    {'code': '+57', 'flag': '🇨🇴', 'name': 'Colombia'},
    {'code': '+34', 'flag': '🇪🇸', 'name': 'Spain'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'code': '+33', 'flag': '🇫🇷', 'name': 'France'},
    {'code': '+49', 'flag': '🇩🇪', 'name': 'Germany'},
    {'code': '+39', 'flag': '🇮🇹', 'name': 'Italy'},
    {'code': '+81', 'flag': '🇯🇵', 'name': 'Japan'},
    {'code': '+86', 'flag': '🇨🇳', 'name': 'China'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+61', 'flag': '🇦🇺', 'name': 'Australia'},
    {'code': '+55', 'flag': '🇧🇷', 'name': 'Brazil'},
    {'code': '+54', 'flag': '🇦🇷', 'name': 'Argentina'},
  ];
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Select Country Code',
                  style: TextStyle(
                    fontFamily: 'Delight',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              // Countries list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        country['name']!,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        country['code']!,
                        style: const TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Only allow +1 for now (USA/Canada validation)
                        if (country['code'] == '+1') {
                          setState(() {
                            _selectedCountryCode = country['code']!;
                            _selectedCountryFlag = country['flag']!;
                            _selectedCountryName = country['name']!;
                          });
                          Navigator.pop(context);
                        } else {
                          // Show message that only +1 is supported for now
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Only United States (+1) is currently supported',
                                style: const TextStyle(fontFamily: 'Delight'),
                              ),
                              backgroundColor: _errorRed,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _handleContinue() {
    setState(() {
      _showError = false;
    });
    
    // Check if field is empty
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'The mobile number, email and/or password are not valid.';
      });
      return;
    }
    
    // Validate format
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      
      // Navigate to create password screen with phone
      Navigator.pushNamed(
        context,
        '/create-password',
        arguments: {
          'phone': phone,
          'countryCode': _selectedCountryCode,
          'registrationType': 'phone',
        },
      );
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'The mobile number, email and/or password are not valid.';
      });
    }
  }
  
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // For +1 (USA/Canada), validate 10 digits
    if (_selectedCountryCode == '+1') {
      if (digitsOnly.length != 10) {
        return 'Please enter a valid 10-digit phone number';
      }
    }
    
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      
                      const SizedBox(height: 32),
                      
                      // Title
                      const Text(
                        'Let\'s get started',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Subtitle
                      const Text(
                        'Create your account to join ForEverUs In Love',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Mobile Number label
                      const Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Phone input with country code
                      Row(
                        children: [
                          // Country code selector
                          InkWell(
                            onTap: _showCountryPicker,
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: _showError ? _errorRed : Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedCountryFlag,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedCountryCode,
                                    style: const TextStyle(
                                      fontFamily: 'Delight',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Phone number input
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: _validatePhone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: const TextStyle(
                                fontFamily: 'Delight',
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                // Clear error when user starts typing
                                if (_showError) {
                                  setState(() {
                                    _showError = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '+1 555-123-4567',
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(color: Colors.black, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(
                                    color: _showError ? _errorRed : Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(
                                    color: _showError ? _errorRed : _primaryGreen,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(color: _errorRed, width: 1.5),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: const BorderSide(color: _errorRed, width: 2),
                                ),
                                errorStyle: const TextStyle(height: 0, fontSize: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Error message alert box (if validation fails)
                      if (_showError)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: _errorBackground,
                            border: Border.all(color: _errorRed, width: 1),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: _errorRed,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    fontFamily: 'Delight',
                                    fontSize: 14,
                                    color: Colors.red[900],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      if (_showError) const SizedBox(height: 24),
                      
                      // Info message box
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _infoBackground,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'We require it only to verify your account, it will never be displayed on your profile.',
                                style: TextStyle(
                                  fontFamily: 'Delight',
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Create account button - Fixed at bottom
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create account',
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
