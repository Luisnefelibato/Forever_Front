import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// Verification Introduction Page
/// 
/// Esta pantalla muestra información sobre por qué es importante la verificación
/// y ofrece proceder con el pago para iniciar el proceso de verificación.
/// 
/// Flujo:
/// 1. Usuario llega después de completar About You
/// 2. Ve información sobre verificación
/// 3. Puede proceder al pago ($1.99) o saltar
/// 4. Si procede, se integra con Google Pay/Apple Pay
/// 5. Después del pago exitoso, se lanza Onfido SDK
/// 6. Después de Onfido, regresa a la app cuando esté verificado
class VerificationIntroPage extends StatefulWidget {
  const VerificationIntroPage({super.key});

  @override
  State<VerificationIntroPage> createState() => _VerificationIntroPageState();
}

class _VerificationIntroPageState extends State<VerificationIntroPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(fontFamily: 'Delight'),
      ),
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2CA97B), // mismo verde que AboutYouBirthdatePage
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF2CA97B),
                size: 24,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'Delight',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Why Verification\nMatters',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Description
                    const Text(
                      'To make ForeverUs In Love a real, trustworthy community, every member completes a secure identity check.',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Benefits Section
                    const Text(
                      'What this means for you',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildBenefit('Protection from fake profiles'),
                    const SizedBox(height: 10),
                    _buildBenefit('Safer and more respectful interactions'),
                    const SizedBox(height: 10),
                    _buildBenefit('A verified, trustworthy community'),
                    
                    const SizedBox(height: 24),
                    
                    // Fee Explanation Section
                    const Text(
                      'Why there\'s a small fee',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'The 1.99 USD one-time verification fee helps us keep our community safe using advanced biometric technology and human moderation.',
                      style: TextStyle(
                        fontFamily: 'Delight',
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Privacy Notice
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Your privacy is protected — your data is encrypted and never shared.',
                              style: TextStyle(
                                fontFamily: 'Delight',
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Proceed Button - Fixed at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleProceedToPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CA97B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
              child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Proceed to pay verification',
                          style: TextStyle(
                            fontFamily: 'Delight',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFD1F2DD),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF2CA97B),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Delight',
              fontSize: 16,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSkip() {
    // Advertir al usuario antes de saltar
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Skip Verification?',
          style: TextStyle(
            fontFamily: 'Delight',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'Without verification, you may have limited access to features and other verified members may not trust your profile.\n\nAre you sure you want to skip?',
          style: TextStyle(
            fontFamily: 'Delight',
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Delight',
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'You can verify your identity later from settings',
                    style: TextStyle(fontFamily: 'Delight'),
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text(
              'Skip Anyway',
              style: TextStyle(
                fontFamily: 'Delight',
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleProceedToPay() async {
    setState(() => _isProcessing = true);

    try {
      // Navegar a la pantalla de pago
      // La pantalla de pago manejará todo: pago -> Onfido SDK -> resultado
      final result = await Navigator.pushNamed(
        context,
        '/verification/payment',
      );

      if (!mounted) return;

      if (result == true) {
        // La verificación se completó exitosamente
        // Mostrar mensaje de éxito y regresar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verification completed successfully!',
              style: TextStyle(fontFamily: 'Delight'),
            ),
            backgroundColor: Color(0xFF2CA97B),
            duration: Duration(seconds: 3),
          ),
        );

        // Regresar a la pantalla anterior con resultado exitoso
        Navigator.pop(context, true);
      } else if (result == false) {
        // La verificación fue cancelada o falló
        // Ya se mostró un mensaje en la pantalla de pago
        // Solo regresamos a esta pantalla para que el usuario pueda intentar de nuevo
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Delight'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
      }
    } finally {
      if (mounted && _isProcessing) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
