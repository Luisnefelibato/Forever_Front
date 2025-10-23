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
/// Colors to be updated with final design:
/// - Background: White/Light - TODO: Update with design
/// - Primary button: Accent color - TODO: Update with design
/// - Text colors: Dark/Gray - TODO: Update with design
/// - Toggle active: Primary color - TODO: Update with design
/// - Toggle inactive: Gray - TODO: Update with design
class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _locationEnabled = false;
  bool _cameraEnabled = false;
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Update background color with final design
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Placeholder icon (32x32 gray circle)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300], // TODO: Replace with app icon
                    ),
                  ),
                  // Skip button
                  TextButton(
                    onPressed: () {
                      // Navigate to home or next screen
                      Navigator.pushReplacementNamed(context, '/home');
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

            const SizedBox(height: 40),

            // Permission items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildPermissionItem(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                      isEnabled: _locationEnabled,
                      onToggle: (value) {
                        setState(() => _locationEnabled = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildPermissionItem(
                      icon: Icons.camera_alt_outlined,
                      title: 'Camera',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                      isEnabled: _cameraEnabled,
                      onToggle: (value) {
                        setState(() => _cameraEnabled = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildPermissionItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                      isEnabled: _notificationsEnabled,
                      onToggle: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                  ],
                ),
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
                        // TODO: Update button color with design
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Allow All',
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
                        'Customize Permission',
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
            color: Colors.grey[200], // TODO: Update with design color
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.grey[700], // TODO: Update with design color
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
          // TODO: Update switch colors with design
          activeColor: Colors.blue,
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

    // Navigate to home
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
