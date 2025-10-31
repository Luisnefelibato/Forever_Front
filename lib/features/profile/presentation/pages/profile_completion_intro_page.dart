import 'package:flutter/material.dart';

/// Profile Completion Intro Page
/// 
/// Pantalla introductoria después de la verificación que invita
/// al usuario a completar su perfil. Usa imagen de fondo con 
/// gradiente de desenfoque en la parte inferior para legibilidad.
/// 
/// Design specs:
/// - Background: Imagen de pareja con gradiente inferior
/// - Gradient: De transparente a negro desde el mentón hacia abajo
/// - Texto principal: "Love starts with understanding."
/// - Subtítulo descriptivo
/// - Botón: "Start now" verde #2CA97B
class ProfileCompletionIntroPage extends StatelessWidget {
  const ProfileCompletionIntroPage({super.key});

  static const Color _primaryGreen = Color(0xFF2CA97B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (pareja mayor)
          // TODO: Agregar imagen profile_intro_couple.jpg en assets/images/onboarding/
          // La imagen debe mostrar una pareja mayor sonriendo (similar a las pantallas de diseño)
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/profile_intro_couple.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback con imagen de assets existente
                return Image.asset(
                  'assets/images/logo/couple_background.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback final con gradiente
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade200,
                            Colors.purple.shade200,
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Gradient overlay for text readability
          // Comienza desde el mentón (60% de altura) hacia abajo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.5, 0.65, 0.85, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Main title
                  const Text(
                    'Love starts with\nunderstanding.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subtitle
                  const Text(
                    'Complete your profile and start connecting\nwith people who share your energy and\ndesires.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Delight',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Start now button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar a la página de bio
                        Navigator.pushNamed(context, '/profile-bio');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Start now',
                        style: TextStyle(
                          fontFamily: 'Delight',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
