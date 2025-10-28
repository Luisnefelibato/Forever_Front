import 'package:flutter/material.dart';
import 'dart:io' show Platform;
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
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Payment Amount Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF34C759),
                      Color(0xFF28A745),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF34C759).withOpacity(0.3),
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
              
              const SizedBox(height: 32),
              
              // Payment Details
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildPaymentDetailRow('Service', 'Identity Verification'),
              const Divider(height: 24),
              _buildPaymentDetailRow('Amount', '\$1.99 USD'),
              const Divider(height: 24),
              _buildPaymentDetailRow('Processing Fee', 'Included'),
              const Divider(height: 24),
              _buildPaymentDetailRow('Total', '\$1.99 USD', isBold: true),
              
              const SizedBox(height: 32),
              
              // Payment Method Info
              Container(
                padding: const EdgeInsets.all(16),
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
                      size: 24,
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
                  padding: const EdgeInsets.all(16),
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
                        size: 24,
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
              
              const Spacer(),
              
              // Pay Button with Platform-specific icon
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
              
              const SizedBox(height: 16),
              
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
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
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
      // TODO: Integrar con el servicio de pago real
      // Por ahora simulamos el proceso de pago
      
      // Simular procesamiento de pago
      await Future<void>.delayed(const Duration(seconds: 2));
      
      // Simulación: 90% de éxito
      final success = DateTime.now().second % 10 != 0;
      
      if (!success) {
        throw Exception('Payment failed. Please try again.');
      }

      // Pago exitoso - iniciar proceso completo de verificación
      final paymentTransactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
      
      // Iniciar proceso completo de verificación (sin backend)
      final verificationSuccess = await OnfidoService.startCompleteVerification(
        userId: 'current_user_id', // TODO: Obtener del estado de autenticación
        paymentTransactionId: paymentTransactionId,
      );

      if (!mounted) return;

      if (verificationSuccess) {
        // Verificación completada exitosamente
        Navigator.pop(context, true);
      } else {
        // Usuario canceló o hubo un error
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
            content: Text('Payment failed: $_errorMessage'),
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
