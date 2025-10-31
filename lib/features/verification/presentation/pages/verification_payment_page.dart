import 'package:flutter/material.dart';
import 'verification_processing_page.dart';
import 'verification_complete_page.dart';
import '../../data/services/onfido_service.dart';

/// Verification Payment Page
/// 
/// Esta pantalla inicia directamente la verificación con Onfido SDK
/// sin proceso de pago.
class VerificationPaymentPage extends StatefulWidget {
  const VerificationPaymentPage({super.key});

  @override
  State<VerificationPaymentPage> createState() => _VerificationPaymentPageState();
}

class _VerificationPaymentPageState extends State<VerificationPaymentPage> {
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Iniciar verificación automáticamente al entrar a la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVerification();
    });
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Verification',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: _isProcessing
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2CA97B)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage ?? 'Starting verification...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: 'Delight',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : _errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Delight',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _errorMessage = null;
                                });
                                _startVerification();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2CA97B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Future<void> _startVerification() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      if (!mounted) return;

      // Ejecutar Onfido directamente desde el frontend (sin backend)
      print('🚀 Iniciando Onfido SDK desde frontend...');

      // Usar userId temporal - no se valida ni se usa en backend
      final userId = 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
      final paymentTransactionId = 'txn_temp_${DateTime.now().millisecondsSinceEpoch}';

      // TEST: Primero probar la conexión con Onfido
      print('\n🧪 Ejecutando test de conexión con Onfido...');
      final testResult = await OnfidoService.testOnfidoConnection();

      if (!testResult['success']) {
        print('❌ Test de conexión falló, pero continuando...');
        print('   Error: ${testResult['error']}');
      } else {
        print('✅ Test de conexión exitoso, continuando con verificación...');
      }

      // Ejecutar Onfido directamente usando el servicio
      // Este método obtiene credenciales reales de Onfido y lanza el SDK
      print('\n🚀 Iniciando verificación completa...');
      final verificationSuccess = await OnfidoService.startCompleteVerification(
        userId: userId,
        paymentTransactionId: paymentTransactionId,
      );

      if (!mounted) return;

      if (verificationSuccess) {
        // Verificación completada exitosamente
        print('✅ Verificación de Onfido completada exitosamente');
        // Navegar a la pantalla de confirmación de verificación completada
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const VerificationCompletePage(),
          ),
        );
      } else {
        // Usuario canceló o hubo un error en Onfido
        print('⚠️ Verificación cancelada o falló');
        setState(() {
          _errorMessage = 'Verification was cancelled or failed. Please try again.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $_errorMessage',
              style: const TextStyle(fontFamily: 'Delight'),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
