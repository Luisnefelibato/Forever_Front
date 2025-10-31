import 'package:flutter/material.dart';

class ProfileInterestsPage extends StatefulWidget {
  const ProfileInterestsPage({super.key});

  @override
  State<ProfileInterestsPage> createState() => _ProfileInterestsPageState();
}

class _ProfileInterestsPageState extends State<ProfileInterestsPage> {
  final Set<String> _selectedInterests = {};
  final Map<String, bool> _expandedCategories = {
    'hobbies': true,
    'education': false,
    'workLife': false,
    'parenthood': false,
    'personality': false,
    'pets': false,
  };

  static const int maxInterests = 10;

  // Category data with icons and interests
  final Map<String, Map<String, dynamic>> _categories = {
    'hobbies': {
      'title': 'Hobbies & Interests',
      'icon': Icons.palette_outlined,
      'interests': [
        'Reading',
        'Traveling',
        'Cooking',
        'Photography',
        'Music',
        'Sports',
        'Gaming',
        'Art & Crafts',
      ],
    },
    'education': {
      'title': 'Education',
      'icon': Icons.school_outlined,
      'interests': [
        'High School',
        'Bachelor\'s Degree',
        'Master\'s Degree',
        'PhD',
        'Vocational Training',
        'Self-taught',
        'Currently Studying',
      ],
    },
    'workLife': {
      'title': 'Work-Life Balance',
      'icon': Icons.work_outline,
      'interests': [
        'Career-focused',
        'Work-life balance',
        'Entrepreneur',
        'Freelancer',
        'Remote work',
        'Traditional office',
        'Flexible schedule',
      ],
    },
    'parenthood': {
      'title': 'Parenthood',
      'icon': Icons.family_restroom_outlined,
      'interests': [
        'Want children',
        'Don\'t want children',
        'Have children',
        'Open to children',
        'Not sure yet',
        'Prefer not to say',
      ],
    },
    'personality': {
      'title': 'Personality & Values',
      'icon': Icons.favorite_outline,
      'interests': [
        'Adventurous',
        'Homebody',
        'Social butterfly',
        'Introverted',
        'Spontaneous',
        'Planner',
        'Optimistic',
        'Realistic',
        'Spiritual',
        'Intellectual',
      ],
    },
    'pets': {
      'title': 'Pets',
      'icon': Icons.pets_outlined,
      'interests': [
        'Dog lover',
        'Cat lover',
        'Have pets',
        'Don\'t have pets',
        'Want pets',
        'Allergic to pets',
        'Other pets',
      ],
    },
  };

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length >= maxInterests) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can select a maximum of $maxInterests interests'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          return;
        }
        _selectedInterests.add(interest);
      }
    });
  }

  void _toggleCategory(String categoryKey) {
    setState(() {
      _expandedCategories[categoryKey] = !_expandedCategories[categoryKey]!;
    });
  }

  void _handleContinue() {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one interest'),
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

    // TODO: Save selected interests
    // Navigate to next page or home
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '30%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2CA97B),
                        fontFamily: 'Delight',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: LinearProgressIndicator(
                          value: 0.30,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2CA97B),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your Interests',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Delight',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select up to $maxInterests interests that describe you',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Delight',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Scrollable categories
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
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => _toggleCategory(categoryKey),
                          borderRadius: BorderRadius.circular(28),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  category['icon'] as IconData,
                                  color: const Color(0xFF2CA97B),
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
                              children: (category['interests'] as List<String>)
                                  .map((interest) {
                                final isSelected = _selectedInterests.contains(interest);
                                return FilterChip(
                                  label: Text(interest),
                                  selected: isSelected,
                                  onSelected: (_) => _toggleInterest(interest),
                                  backgroundColor: Colors.grey[100],
                                  selectedColor: const Color(0xFF2CA97B).withOpacity(0.2),
                                  checkmarkColor: const Color(0xFF2CA97B),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF2CA97B)
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontFamily: 'Delight',
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xFF2CA97B)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
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
      floatingActionButton: _selectedInterests.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _handleContinue,
              backgroundColor: const Color(0xFF2CA97B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              label: Row(
                children: [
                  Text(
                    'Continue (${_selectedInterests.length}/$maxInterests)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Delight',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            )
          : null,
    );
  }
}
