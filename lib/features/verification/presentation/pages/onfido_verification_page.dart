import 'package:flutter/material.dart';

/// Onfido Verification Page
/// 
/// Esta pantalla inicia el SDK de Onfido para la verificación de identidad.
/// El SDK maneja:
/// - Captura de documento (ID, pasaporte, licencia)
/// - Captura facial (selfie/video)
/// - Detección de vida (liveness)
/// - Lectura NFC (si está disponible)
/// 
/// Después de completar, el SDK retorna a la app.
/// Solo se regresa cuando la persona se haya verificado completamente.
class OnfidoVerificationPage extends StatefulWidget {
  final String sdkToken;
  final String workflowRunId;

  const OnfidoVerificationPage({
    super.key,
    required this.sdkToken,
    required this.workflowRunId,
  });

  @override
  State<OnfidoVerificationPage> createState() => _OnfidoVerificationPageState();
}

class _OnfidoVerificationPageState extends State<OnfidoVerificationPage> {
  bool _isInitializing = true;
  String _statusMessage = 'Initializing verification...';

  @override
  void initState() {
    super.initState();
    _initializeOnfido();
  }

  Future<void> _initializeOnfido() async {
    try {
      setState(() {
        _statusMessage = 'Preparing identity verification...';
      });

      // Simular inicialización del SDK
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Integrar con el SDK real de Onfido
      // final onfidoService = GetIt.instance<OnfidoVerificationService>();
      // final result = await onfidoService.startVerification(
      //   sdkToken: widget.sdkToken,
      //   workflowRunId: widget.workflowRunId,
      // );

      // Por ahora, simulamos el proceso
      await _simulateOnfidoFlow();
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> _simulateOnfidoFlow() async {
    // Simulación del flujo de Onfido
    final steps = [
      'Verifying SDK token...',
      'Loading verification workflow...',
      'Preparing document capture...',
      'Launching Onfido SDK...',
    ];

    for (final step in steps) {
      if (!mounted) return;
      setState(() => _statusMessage = step);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    // Simular que el SDK de Onfido se lanza aquí
    // En la implementación real, esto lanzaría el SDK nativo
    await _showOnfidoSimulation();
  }

  Future<void> _showOnfidoSimulation() async {
    // Mostrar diálogo simulando el SDK de Onfido
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _OnfidoSimulationDialog(),
    );

    if (!mounted) return;

    if (result == true) {
      // Verificación completada
      await _handleVerificationComplete();
    } else {
      // Usuario canceló
      _handleCancellation();
    }
  }

  Future<void> _handleVerificationComplete() async {
    setState(() {
      _statusMessage = 'Verification completed! Processing results...';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Regresar a la app con resultado exitoso
    Navigator.pop(context, true);

    // En el flujo real, aquí se polling al backend para obtener el resultado
    // o se espera el webhook del backend que confirme la verificación
  }

  void _handleCancellation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Verification Cancelled',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'You can complete the verification process later from your profile settings.',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, false); // Return to previous screen
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleError(String error) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'Error',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          'An error occurred during verification:\n\n$error',
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, false); // Return to previous screen
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          // Confirmar antes de cancelar la verificación
          final shouldCancel = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Cancel Verification?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: const Text(
                'Are you sure you want to cancel the verification process?',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'No, Continue',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Yes, Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );

          return shouldCancel ?? false;
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Loading Indicator
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34C759)),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Status Message
                  Text(
                    _statusMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Info Text
                  const Text(
                    'Please do not close the app',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog que simula el SDK de Onfido
/// En la implementación real, esto sería reemplazado por el SDK nativo
class _OnfidoSimulationDialog extends StatefulWidget {
  @override
  State<_OnfidoSimulationDialog> createState() => _OnfidoSimulationDialogState();
}

class _OnfidoSimulationDialogState extends State<_OnfidoSimulationDialog> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Select Document Type',
    'Capture Document Front',
    'Capture Document Back',
    'NFC Reading (Optional)',
    'Facial Capture',
    'Liveness Check',
    'Uploading & Processing',
  ];

  @override
  void initState() {
    super.initState();
    _simulateSteps();
  }

  Future<void> _simulateSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      await Future.delayed(const Duration(seconds: 2));
    }

    if (mounted) {
      // Completado
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Onfido Logo (simulated)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user,
                color: Colors.blue,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Onfido Verification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Current Step
            Text(
              _steps[_currentStep],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Progress
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Step ${_currentStep + 1} of ${_steps.length}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
