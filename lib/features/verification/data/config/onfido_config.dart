/// Configuración de Onfido para la aplicación ForeverUsInLove
class OnfidoConfig {
  // Información del Workflow
  static const String workflowName = 'flutter_new';
  static const String workflowId = '2e849672-bc5e-449a-9feb-c40ccde8b575';
  
  // Token de API (LIVE - Producción)
  static const String apiToken = 'EYFA0st4yuXDVrldNshBRtj4zfIgAoAlw89BsvnZ4IE';
  
  // Entorno actual
  static const String environment = 'live';
  
  // Versiones mínimas soportadas
  static const Map<String, String> minVersions = {
    'web': '14.39.0',
    'android': '22.1.0',
    'ios': '32.1.0',
  };
  
  // Configuración de la apariencia
  static const Map<String, dynamic> appearance = {
    'primaryColor': 0xFF34C759, // Verde de la app
    'secondaryColor': 0xFF28A745, // Verde más oscuro
    'supportDarkMode': true,
  };
  
  // Configuración del flujo
  static const Map<String, bool> flowSteps = {
    'welcome': true,
    'documentCapture': true,
    'faceCapture': true,
    'documentSelection': true,
    'nfcReading': true, // Opcional
  };
  
  // Configuración regional
  static const String locale = 'en_US';
  static const String region = 'US';
  
  // URLs del backend
  static const String baseUrl = 'http://3.232.35.26:8000/api/v1';
  static const String verificationEndpoint = '$baseUrl/verification';
  
  // Configuración de timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Configuración de reintentos
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
