import 'package:flutter/material.dart';

/// Profile Height Page
/// 
/// Allows users to select their height in feet and inches.
class ProfileHeightPage extends StatefulWidget {
  const ProfileHeightPage({super.key});

  @override
  State<ProfileHeightPage> createState() => _ProfileHeightPageState();
}

class _ProfileHeightPageState extends State<ProfileHeightPage> {
  int _selectedFeet = 6;
  int _selectedInches = 6;
  
  static const Color _primaryGreen = Color(0xFF2CA97B);
  
  final List<int> _feetOptions = List.generate(5, (index) => index + 4); // 4ft to 8ft
  final List<int> _inchesOptions = List.generate(12, (index) => index); // 0in to 11in

  void _handleSkip() {
    Navigator.pushNamed(context, '/profile-job');
  }

  void _handleNext() {
    // Save height data
    final heightData = {
      'feet': _selectedFeet,
      'inches': _selectedInches,
    };
    
    debugPrint('Selected height: $_selectedFeet ft $_selectedInches in');
    
    // Navigate to job page
    Navigator.pushNamed(
      context,
      '/profile-job',
      arguments: heightData,
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
                    value: 0.65,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'What\'s your height?',
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
                  'You can change or remove this later.',
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
          
          // Height pickers
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Feet picker
                Expanded(
                  child: _buildHeightPicker(
                    options: _feetOptions,
                    selectedValue: _selectedFeet,
                    suffix: 'ft',
                    onChanged: (value) {
                      setState(() {
                        _selectedFeet = value;
                      });
                    },
                  ),
                ),
                
                const SizedBox(width: 32),
                
                // Inches picker
                Expanded(
                  child: _buildHeightPicker(
                    options: _inchesOptions,
                    selectedValue: _selectedInches,
                    suffix: 'in',
                    onChanged: (value) {
                      setState(() {
                        _selectedInches = value;
                      });
                    },
                  ),
                ),
              ],
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

  Widget _buildHeightPicker({
    required List<int> options,
    required int selectedValue,
    required String suffix,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.map((value) {
        final isSelected = value == selectedValue;
        return GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? _primaryGreen : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              '$value $suffix',
              style: TextStyle(
                fontSize: isSelected ? 20 : 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[400],
                fontFamily: 'Delight',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
