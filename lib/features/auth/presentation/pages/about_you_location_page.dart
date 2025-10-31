import 'package:flutter/material.dart';

/// About You - Location Screen
/// 
/// Design Specifications:
/// - Back button at top left (circular with green border)
/// - Progress bar showing ~70% completion
/// - Title: "Where do live?" (Bold, large, black)
/// - Subtitle: "Let us know your city, it helps us find people nearby..."
/// - Search input field with placeholder "Type your location"
/// - Search icon on right side of input
/// - Dropdown list with search results
/// - Selected city shows green background with black filled circle
/// - Error state: "Required to select" message in red below input
/// - Green FAB with arrow icon at bottom right
/// 
/// Validation:
/// - One location must be selected from the dropdown
/// - Red error message appears if trying to proceed without selection
class AboutYouLocationPage extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? countryCode;
  final int? birthDay;
  final int? birthMonth;
  final int? birthYear;
  final String? gender;
  final String? interests;
  final String? lookingFor;
  
  const AboutYouLocationPage({
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
    this.interests,
    this.lookingFor,
  });

  @override
  State<AboutYouLocationPage> createState() => _AboutYouLocationPageState();
}

class _AboutYouLocationPageState extends State<AboutYouLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocation;
  bool _showError = false;
  bool _hasAttemptedSubmit = false;
  bool _showDropdown = false;
  List<String> _filteredLocations = [];
  
  // Color constants
  static const Color _primaryGreen = Color(0xFF2CA97B);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _progressGray = Color(0xFFE0E0E0);
  
  // Sample locations (in production, this would come from an API)
  final List<String> _allLocations = [
    'Bogotá, Bogota, Colombia',
    'Medellín, Antioquia, Colombia',
    'Cali, Valle del Cauca, Colombia',
    'Barranquilla, Atlántico, Colombia',
    'Cartagena, Bolívar, Colombia',
    'Bucaramanga, Santander, Colombia',
    'Buenos Aires, Argentina',
    'Córdoba, Argentina',
    'Rosario, Santa Fe, Argentina',
    'Mexico City, Mexico',
    'Guadalajara, Jalisco, Mexico',
    'Monterrey, Nuevo León, Mexico',
    'Madrid, Spain',
    'Barcelona, Catalonia, Spain',
    'Valencia, Spain',
    'New York, NY, USA',
    'Los Angeles, CA, USA',
    'Chicago, IL, USA',
    'London, England, UK',
    'Manchester, England, UK',
    'Birmingham, England, UK',
  ];
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = [];
        _showDropdown = false;
      } else {
        _filteredLocations = _allLocations
            .where((location) => location.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showDropdown = _filteredLocations.isNotEmpty;
      }
      
      // Reset selection if user is typing
      if (_selectedLocation != null && 
          _searchController.text != _selectedLocation) {
        _selectedLocation = null;
        if (_hasAttemptedSubmit) {
          _showError = true;
        }
      }
    });
  }
  
  void _selectLocation(String location) {
    setState(() {
      _selectedLocation = location;
      _searchController.text = location;
      _showDropdown = false;
      _filteredLocations = [];
      if (_hasAttemptedSubmit) {
        _showError = false;
      }
    });
  }
  
  void _validateAndContinue() {
    setState(() {
      _hasAttemptedSubmit = true;
      _showError = _selectedLocation == null;
    });
    
    if (!_showError) {
      // Navigate to verification prompt screen
      Navigator.pushNamed(
        context,
        '/verification-prompt',
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
          'interests': widget.interests,
          'lookingFor': widget.lookingFor,
          'location': _selectedLocation,
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
                'Where do live?',
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
                'Let us know your city, it helps us find people nearby who share your lifestyle and values',
                style: TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Search input field
              _buildSearchField(),
              
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
              
              // Dropdown list
              if (_showDropdown) ...[
                const SizedBox(height: 16),
                _buildDropdownList(),
              ],
              
              // Selected location display
              if (_selectedLocation != null && !_showDropdown) ...[
                const SizedBox(height: 16),
                _buildSelectedLocation(),
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
          value: 0.7, // 70% progress
          backgroundColor: _progressGray,
          valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
        ),
      ),
    );
  }
  
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(
        fontFamily: 'Delight',
        fontSize: 14,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Type your location',
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
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.black,
          size: 24,
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
            color: _showError ? _errorRed : Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
  
  Widget _buildDropdownList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _filteredLocations.length,
        itemBuilder: (context, index) {
          final location = _filteredLocations[index];
          return InkWell(
            onTap: () => _selectLocation(location),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                border: index < _filteredLocations.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Text(
                location,
                style: const TextStyle(
                  fontFamily: 'Delight',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSelectedLocation() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _primaryGreen,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location text
          Expanded(
            child: Text(
              _selectedLocation!,
              style: const TextStyle(
                fontFamily: 'Delight',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Selected indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.circle,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
