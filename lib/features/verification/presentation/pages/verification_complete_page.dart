import 'package:flutter/material.dart';

/// Verification Complete Page
/// 
/// Pantalla de confirmación que se muestra después de completar
/// la verificación con Onfido SDK.
/// 
/// Muestra el logo de la app, mensaje de éxito y botón para finalizar.
class VerificationCompletePage extends StatefulWidget {
  const VerificationCompletePage({super.key});

  @override
  State<VerificationCompletePage> createState() => _VerificationCompletePageState();
}

class _VerificationCompletePageState extends State<VerificationCompletePage> {
  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(fontFamily: 'Delight'),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Logo de fondo (igual que en login_page.dart)
            _buildBackgroundLogo(),
            
            // Contenido principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    
                    // Llavecita morada en el centro
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Color(0xFF6A4C93), // Color morado
                        size: 60,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Mensaje de confirmación
                    const Text(
                      'Your registration\nis complete',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2CA97B), // Verde verificación
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 80),
                    
                    // Botón Finish
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('🔄 [VERIFICATION_COMPLETE] Botón Finish presionado');
                          debugPrint('🔄 [VERIFICATION_COMPLETE] Navegando a /profile-intro...');
                          
                          // Usar ruta nombrada directamente
                          Navigator.pushReplacementNamed(context, '/profile-intro').then((_) {
                            debugPrint('✅ [VERIFICATION_COMPLETE] Navegación completada exitosamente');
                          }).catchError((error) {
                            debugPrint('❌ [VERIFICATION_COMPLETE] Error en navegación: $error');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2CA97B), // Verde verificación
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Delight',
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el logo de fondo exactamente como en login_page.dart
  Widget _buildBackgroundLogo() {
    return Positioned(
      top: -370,
      right: -400,
      child: Opacity(
        opacity: 0.15, // Slightly more visible
        child: Image.asset(
          'assets/images/logo/Logo_Login.png',
          width: 1000,
          height: 1000,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}