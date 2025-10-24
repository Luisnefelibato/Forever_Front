import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// About You - Birthdate Screen
/// 
/// Design Specifications:
/// - Back button at top left (circular with green border)
/// - Progress bar showing ~30% completion
/// - Title: "How old are you?" (Bold, large, black)
/// - Description: Multi-line text about age requirement
/// - Three rounded input fields: Day, Month, Year
/// - Bottom sheet date picker with green background
/// - Scrollable iOS-style picker for day, month, year
/// - "Continue" button in white at bottom of picker
/// - Error states:
///   * Red borders on date fields when empty and trying to proceed
///   * Pink alert box with icon when user is under 18
/// - Valid state: Shows selected date (e.g., "04 June 1990")
/// 
/// Validation:
/// - All date fields required before proceeding
/// - User must be 18 years or older
/// - Date must be valid
class AboutYouBirthdatePage extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  
  const AboutYouBirthdatePage({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
  });

  @override
  State<AboutYouBirthdatePage> createState() => _AboutYouBirthdatePageState();
}

class _AboutYouBirthdatePageState extends State<AboutYouBirthdatePage> {
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  
  bool _showDateError = false;
  bool _showAgeError = false;
  bool _hasAttemptedSubmit = false;
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _errorBackground = Color(0xFFFFEBEE);
  static const Color _progressGray = Color(0xFFE0E0E0);
  static const Color _placeholderGray = Color(0xFF9E9E9E);
  
  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  @override
  void dispose() {
    super.dispose();
  }
  
  void _showDatePicker() {
    // Reset error when opening picker
    setState(() {
      _showDateError = false;
      _showAgeError = false;
    });
    
    showModalBottomSheet(
      context: context,
      backgroundColor: _primaryGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return _buildDatePickerSheet();
      },
    );
  }
  
  Widget _buildDatePickerSheet() {
    int tempDay = _selectedDay ?? 1;
    int tempMonth = _selectedMonth ?? 1;
    int tempYear = _selectedYear ?? 2000;
    
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Title
          const Text(
            'Date of birth',
            style: TextStyle(
              fontFamily: 'Delight',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Date picker
          Expanded(
            child: Row(
              children: [
                // Day picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: tempDay - 1,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      tempDay = index + 1;
                    },
                    children: List.generate(31, (index) {
                      return Center(
                        child: Text(
                          '${index + 1}'.padLeft(2, '0'),
                          style: const TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Month picker
                Expanded(
                  flex: 2,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: tempMonth - 1,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      tempMonth = index + 1;
                    },
                    children: _monthNames.map((month) {
                      return Center(
                        child: Text(
                          month,
                          style: const TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Year picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: 2024 - tempYear,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      tempYear = 2024 - index;
                    },
                    children: List.generate(100, (index) {
                      return Center(
                        child: Text(
                          '${2024 - index}',
                          style: const TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedDay = tempDay;
                  _selectedMonth = tempMonth;
                  _selectedYear = tempYear;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _validateAndContinue() {
    setState(() {
      _hasAttemptedSubmit = true;
      _showDateError = _selectedDay == null || 
                        _selectedMonth == null || 
                        _selectedYear == null;
      _showAgeError = false;
    });
    
    if (_showDateError) {
      return;
    }
    
    // Validate age (must be 18+)
    final now = DateTime.now();
    final birthDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
    final age = now.year - birthDate.year - 
                ((now.month > birthDate.month || 
                 (now.month == birthDate.month && now.day >= birthDate.day)) 
                 ? 0 : 1);
    
    if (age < 18) {
      setState(() {
        _showAgeError = true;
      });
      return;
    }
    
    // Success - navigate to next screen
    // TODO: Navigate to next step (gender/interests)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Birthdate validated successfully!'),
        backgroundColor: _primaryGreen,
      ),
    );
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
              
              const SizedBox(height: 48),
              
              // Title
              const Text(
                'How old are you?',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              const Text(
                'ForeverUs InLove is a space for adults over 18. Tell us your age to personalize your experience',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Date input fields
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: _selectedDay?.toString().padLeft(2, '0') ?? 'Day',
                      isPlaceholder: _selectedDay == null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildDateField(
                      label: _selectedMonth != null 
                          ? _monthNames[_selectedMonth! - 1] 
                          : 'Month',
                      isPlaceholder: _selectedMonth == null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      label: _selectedYear?.toString() ?? 'Year',
                      isPlaceholder: _selectedYear == null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Age error message
              if (_showAgeError)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _errorBackground,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: _errorRed,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _errorRed,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '!',
                            style: TextStyle(
                              fontFamily: 'Delight',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _errorRed,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sorry! ForeverUs InLove is only available for users over 18 years old.',
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
          value: 0.3, // 30% progress (step 2 of ~5)
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
        ),
      ),
    );
  }
  
  Widget _buildDateField({
    required String label,
    required bool isPlaceholder,
  }) {
    final bool showError = _showDateError && isPlaceholder;
    
    return GestureDetector(
      onTap: _showDatePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: showError ? _errorRed : Colors.black,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Delight',
              fontSize: 14, // Smaller font size to prevent overflow
              fontWeight: FontWeight.normal,
              color: isPlaceholder ? _placeholderGray : Colors.black,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Handle overflow gracefully
            maxLines: 1, // Single line to prevent wrapping
          ),
        ),
      ),
    );
  }
}
