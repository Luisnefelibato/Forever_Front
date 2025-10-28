/// Rutas de navegación para el módulo de verificación
class VerificationRoutes {
  static const String intro = '/verification/intro';
  static const String payment = '/verification/payment';
  static const String processing = '/verification/processing';
  static const String onfido = '/verification/onfido';
  
  /// Configuración de rutas para GoRouter
  static const Map<String, String> routes = {
    'intro': intro,
    'payment': payment,
    'processing': processing,
    'onfido': onfido,
  };
}
