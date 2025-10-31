import 'package:flutter/material.dart';

/// Profile Lifestyle Page
/// 
/// Allows users to select up to 10 lifestyle choices that reflect who they are.
/// Categories include: Exercise & Activities, Your diet, and Alcohol preferences.
class ProfileLifestylePage extends StatefulWidget {
  const ProfileLifestylePage({super.key});

  @override
  State<ProfileLifestylePage> createState() => _ProfileLifestylePageState();
}

class _ProfileLifestylePageState extends State<ProfileLifestylePage> {
  final Set<String> _selectedLifestyles = {};
  final Map<String, bool> _expandedCategories = {
    'exercise': true,
    'diet': false,
    'alcohol': false,
  };

  static const int maxSelections = 10;
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _purpleIcon = Color(0xFF8B5CF6);

  final Map<String, Map<String, dynamic>> _categories = {
    'exercise': {
      'title': 'Exercise & Activities',
      'icon': Icons.fitness_center,
      'options': [
        'Gym',
        'Swimming',
        'Biking',
        'Yoga',
        'Spinning',
        'Pilates',
        'Barre',
        'Meditation',
        'Hiking',
        'Dancing',
        'Boxing',
        'Running',
        'Padel',
        'Football',
        'Football',
        'Surf',
      ],
    },
    'diet': {
      'title': 'Your diet',
      'icon': Icons.restaurant,
      'options': [
        'I eat everything',
        'Vegetarian',
        'Vegan',
        'Keto',
        'Gluten-free',
        'Foodie',
      ],
    },
    'alcohol': {
      'title': 'Alcohol',
      'icon': Icons.wine_bar,
      'options': [
        'Never',
        'Socially',
        'Regularly',
        'Often',
      ],
    },
  };

  void _toggleSelection(String option) {
    setState(() {
      if (_selectedLifestyles.contains(option)) {
        _selectedLifestyles.remove(option);
      } else {
        if (_selectedLifestyles.length >= maxSelections) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can select a maximum of $maxSelections options'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          return;
        }
        _selectedLifestyles.add(option);
      }
    });
  }

  void _toggleCategory(String categoryKey) {
    setState(() {
      _expandedCategories[categoryKey] = !_expandedCategories[categoryKey]!;
    });
  }

  void _handleSkip() {
    Navigator.pushNamed(context, '/profile-photos');
  }

  void _handleContinue() {
    if (_selectedLifestyles.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select 10 options to continue'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    
    // Navigate to photos page
    Navigator.pushNamed(context, '/profile-photos');
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
                    value: 0.20,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Your lifestyle and\nhabits',
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
                  'Select up to 10 the ones that reflects who\nyou are.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Delight',
                  ),
                ),
                const SizedBox(height: 24),
                
                // Icon placeholders
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Categories list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final categoryKey = _categories.keys.elementAt(index);
                final category = _categories[categoryKey]!;
                final isExpanded = _expandedCategories[categoryKey]!;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => _toggleCategory(categoryKey),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  category['icon'] as IconData,
                                  color: _purpleIcon,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    category['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Delight',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (category['options'] as List<String>)
                                  .map((option) {
                                final isSelected = _selectedLifestyles.contains(option);
                                return InkWell(
                                  onTap: () => _toggleSelection(option),
                                  borderRadius: BorderRadius.circular(28),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: isSelected
                                            ? _primaryGreen
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: isSelected
                                            ? _primaryGreen
                                            : Colors.grey[700],
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontFamily: 'Delight',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedLifestyles.length == maxSelections
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Delight',
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
