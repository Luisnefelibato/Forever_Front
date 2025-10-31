import 'package:flutter/material.dart';

/// Profile Interests Page
/// 
/// Permite al usuario seleccionar sus intereses de múltiples categorías.
/// Máximo 10 selecciones.
/// 
/// Design specs:
/// - Progress bar: ~30% (verde #2CA97B)
/// - Back button: Circular verde con flecha
/// - Skip button: Top right
/// - Title: "About you and your interests"
/// - Subtitle: "Pick up to 10 that match your style."
/// - Categorías expandibles con iconos
/// - Chips seleccionables con borde verde
/// - Chips seleccionados: Fondo verde, texto negro
/// - Chips no seleccionados: Fondo gris claro, texto gris oscuro
class ProfileInterestsPage extends StatefulWidget {
  const ProfileInterestsPage({super.key});

  @override
  State<ProfileInterestsPage> createState() => _ProfileInterestsPageState();
}

class _ProfileInterestsPageState extends State<ProfileInterestsPage> {
  final Set<String> _selectedInterests = {};
  static const int _maxSelections = 10;
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _progressGray = Color(0xFFE0E0E0);

  // Categorías con sus intereses
  final Map<String, List<String>> _categories = {
    'Hobbies & Interests': [
      'Music festivals',
      'Cooking',
      'Netflix & Chill',
      'Arts & Crafts',
      'Books',
      'Art Exhibitions',
      'Traveling',
      'Outdoor activities',
      'Gardening',
      'Making music',
      'Gaming',
      'Board games',
      'Museums',
      'Dancing',
      'Ceramics',
      'Fashion',
      'Photography',
    ],
    'Education': [
      'High school',
      'Bachelor\'s Degree',
      'Master\'s degree',
      'Doctorate / PhD',
      'Life school',
    ],
    'Work-Life Balance': [
      'Workaholic',
      'Balanced approach',
      'Leisure seeker',
      'Career focused',
      'Family first',
    ],
    'Parenthood': [
      'I have kids',
      'I want kids',
      'I don\'t want kids',
      'Open to kids',
      'Stepparent',
    ],
    'Personality & Values': [
      'Kind',
      'Patient',
      'Romantic',
      'Adventurous',
      'Honest',
      'Ambitious',
      'Creative',
      'Spiritual',
    ],
    'Pets': [
      'I love animals',
      'Dog lover',
      'Cat lover',
      'Exotic pets',
      'No pets',
      'Allergic to pets',
    ],
  };

  // Iconos para cada categoría
  final Map<String, IconData> _categoryIcons = {
    'Hobbies & Interests': Icons.music_note,
    'Education': Icons.school,
    'Work-Life Balance': Icons.work,
    'Parenthood': Icons.child_care,
    'Personality & Values': Icons.favorite,
    'Pets': Icons.pets,
  };

  // Estado de expansión de categorías
  final Map<String, bool> _expandedCategories = {
    'Hobbies & Interests': false,
    'Education': false,
    'Work-Life Balance': false,
    'Parenthood': false,
    'Personality & Values': false,
    'Pets': false,
  };

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < _maxSelections) {
          _selectedInterests.add(interest);
        } else {
          // Mostrar snackbar si se alcanza el límite
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to 10 interests'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      _expandedCategories[category] = !(_expandedCategories[category] ?? false);
    });
  }

  void _handleContinue() {
    // Guardar intereses y navegar a siguiente paso
    // Por ahora navegamos al home
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress, back and skip
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Back and Skip row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      // Skip button
                      TextButton(
                        onPressed: _handleContinue,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progress bar (~30%)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: 0.30,
                      backgroundColor: _progressGray,
                      valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Title
                    const Text(
                      'About you and your\ninterests',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'Pick up to 10 that match your style.',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick selection chips (top picks)
                    if (_selectedInterests.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedInterests.map((interest) {
                          return _buildInterestChip(interest, isSelected: true);
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Categories
                    ..._categories.entries.map((entry) {
                      final category = entry.key;
                      final interests = entry.value;
                      final isExpanded = _expandedCategories[category] ?? false;
                      final icon = _categoryIcons[category] ?? Icons.category;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category header
                          InkWell(
                            onTap: () => _toggleCategory(category),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: _primaryGreen,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontFamily: 'Delight',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Category interests (expandable)
                          if (isExpanded) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: interests.map((interest) {
                                final isSelected = _selectedInterests.contains(interest);
                                return _buildInterestChip(interest, isSelected: isSelected);
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Divider
                          if (category != _categories.keys.last)
                            Divider(color: Colors.grey[300], height: 1),
                        ],
                      );
                    }),

                    const SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Continue button - Floating at bottom
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _selectedInterests.isNotEmpty ? _handleContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
            ),
            child: Text(
              'Continue (${_selectedInterests.length}/$_maxSelections)',
              style: const TextStyle(
                fontFamily: 'Delight',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestChip(String interest, {required bool isSelected}) {
    return InkWell(
      onTap: () => _toggleInterest(interest),
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : Colors.grey[200],
          border: Border.all(
            color: isSelected ? _primaryGreen : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          interest,
          style: TextStyle(
            fontFamily: 'Delight',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}