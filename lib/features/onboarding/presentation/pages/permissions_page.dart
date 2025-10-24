import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permissions Screen
/// 
/// Design Notes:
/// - Skip button: Top right
/// - Icon placeholder: Top left (32x32px gray circle)
/// - Title: "Allow access to personalize your experience."
/// - Three permission items: Location, Camera, Notifications
/// - Each item has: Icon, Title, Description, Toggle
/// - Primary button: "Allow All" - TODO: Update color with design
/// - Secondary button: "Customize Permission"
/// 
/// Colors implemented:
/// - Background: White
/// - Primary button: #2CA97B (Green)
/// - Text colors: Black/Gray
/// - Toggle active: #2CA97B with black border
/// - Toggle inactive: White with black border
class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _locationEnabled = false;
  bool _cameraEnabled = false;
  bool _notificationsEnabled = false;

  // Color constants
  static const Color _allowButtonColor = Color(0xFF2CA97B);
  static const Color _activeToggleColor = Color(0xFF2CA97B);
  static const Color _inactiveToggleColor = Colors.white;
  static const Color _borderColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Update background color with final design
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo/Logo_en_Negativo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to gray circle if image fails to load
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Skip button
                  TextButton(
                    onPressed: () {
                      // Navigate to welcome page
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                    child: Text(
                      'skip',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black, // TODO: Update with design color
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Allow access to\npersonalize\nyour experience.',
                style: TextStyle(
                  // TODO: Update font-family
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: Colors.black, // TODO: Update with design color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Permission items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                    _buildPermissionItem(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      description:
                          'So we can show people near you, safely and respectfully.',
                      isEnabled: _locationEnabled,
                      onToggle: (value) {
                        setState(() => _locationEnabled = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      icon: Icons.camera_alt_outlined,
                      title: 'Camera',
                      description:
                          'We’ll use your camera to verify your ID  ',
                      isEnabled: _cameraEnabled,
                      onToggle: (value) {
                        setState(() => _cameraEnabled = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      description:
                          'Get gentle reminders when someone special connects',
                      isEnabled: _notificationsEnabled,
                      onToggle: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                  ],
                ),
              ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Allow All button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleAllowAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allowButtonColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Allow',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Customize Permission button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      onPressed: () {
                        // Open app settings for manual permission control
                        openAppSettings();
                      },
                      child: Text(
                        'Go to Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black, // TODO: Update with design color
                        ),
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
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return Row(
      children: [
        // Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isEnabled ? _activeToggleColor : _inactiveToggleColor,
            border: Border.all(
              color: _borderColor,
              width: 2.0,
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // TODO: Update with design color
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600], // TODO: Update with design color
                ),
              ),
            ],
          ),
        ),
        // Toggle switch
        Switch(
          value: isEnabled,
          onChanged: onToggle,
          activeColor: Colors.black,
          activeTrackColor: _activeToggleColor,
          activeThumbColor: Colors.black,
          inactiveThumbColor: Colors.black,
          inactiveTrackColor: Colors.white,
          trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
            return Colors.black;
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith<double>((states) {
            return 1.0;
          }),
        ),
      ],
    );
  }

  Future<void> _handleAllowAll() async {
    // Request all permissions
    setState(() {
      _locationEnabled = true;
      _cameraEnabled = true;
      _notificationsEnabled = true;
    });

    // Request actual permissions from system
    await [
      Permission.location,
      Permission.camera,
      Permission.notification,
    ].request();

    // Navigate to welcome page
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }
}
