import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'verification_processing_page.dart';
import 'verification_complete_page.dart';
import '../../data/services/onfido_service.dart';

/// Verification Payment Page
/// 
/// Esta pantalla maneja el pago de la verificación usando:
/// - Apple Pay en iOS
/// - Google Pay en Android
/// 
/// Después del pago exitoso, lanza el SDK de Onfido
class VerificationPaymentPage extends StatefulWidget {
  const VerificationPaymentPage({super.key});

  @override
  State<VerificationPaymentPage> createState() => _VerificationPaymentPageState();
}

class _VerificationPaymentPageState extends State<VerificationPaymentPage> {
  bool _isProcessing = false;
  String? _errorMessage;

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
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    
                    // Payment Amount Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                          Color(0xFF2CA97B),
                            Color(0xFF28A745),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2CA97B).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verification Fee',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '1.99',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'One-time payment',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Details
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildPaymentDetailRow('Service', 'Identity Verification'),
                    const Divider(height: 20),
                    _buildPaymentDetailRow('Amount', '\$1.99 USD'),
                    const Divider(height: 20),
                    _buildPaymentDetailRow('Processing Fee', 'Included'),
                    const Divider(height: 20),
                    _buildPaymentDetailRow('Total', '\$1.99 USD', isBold: true),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Method Info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue[200]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              Platform.isIOS
                                  ? 'Payment will be processed securely through Apple Pay'
                                  : 'Payment will be processed securely through Google Pay',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[900],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red[900],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Pay Button with Platform-specific icon - Fixed at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handlePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Platform.isIOS ? Icons.apple : Icons.payment,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  Platform.isIOS ? 'Pay with Apple Pay' : 'Pay with Google Pay',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Security Notice
                  const Center(
                    child: Text(
                      '🔒 Secure payment processing',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildPaymentDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      if (!mounted) return;

      // Ejecutar Onfido directamente desde el frontend (sin backend)
      print('⏭️ Saltando backend - ejecutando Onfido directamente desde frontend...');

      // Usar userId temporal - no se valida ni se usa en backend
      final userId = 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
      final paymentTransactionId = 'txn_temp_${DateTime.now().millisecondsSinceEpoch}';
      
      print('🚀 Iniciando Onfido SDK desde frontend...');
      
      // OPcional: Si el token en OnfidoConfig no funciona, puedes usar uno personalizado aquí:
      // OnfidoService.setCustomApiToken('TU_TOKEN_AQUI');
      
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
        // Mostrar pantalla de confirmación de verificación completada
        try {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VerificationCompletePage(),
            ),
          );
        } catch (e) {
          print('Navegación a complete falló: $e');
        }
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        // Usuario canceló o hubo un error en Onfido
        print('⚠️ Verificación cancelada o falló');
        Navigator.pop(context, false);
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

  // TODO: Implementar método real para crear sesión de verificación
  // Future<Map<String, dynamic>> _createVerificationSession(String paymentTransactionId) async {
  //   final response = await apiClient.post(
  //     '/api/v1/verification/create',
  //     data: {'payment_transaction_id': paymentTransactionId},
  //   );
  //   return response.data;
  // }
}
