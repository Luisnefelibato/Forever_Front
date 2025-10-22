/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'ForeverUsInLove';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Validation Constants
  static const int nameMaxLength = 25;
  static const int phoneNumberLength = 10;
  static const int emailMaxLength = 100;
  static const int passwordMaxLength = 25;
  static const int passwordMinLength = 8;
  static const int otpCodeLength = 4;
  static const int otpExpirationMinutes = 10;
  static const int otpResendWaitSeconds = 30;
  
  // Image Upload Constants
  static const int minImagesRequired = 2;
  static const int maxImagesAllowed = 6;
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['.jpg', '.jpeg', '.png', '.webp'];
  
  // Age Restriction
  static const int minimumAge = 18;
  
  // Gender Options
  static const List<String> genderOptions = ['Man', 'Woman', 'No Binari'];
  
  // Interest Options
  static const List<String> interestOptions = ['Man', 'Woman', 'Man and Woman'];
  
  // Permission Types
  static const List<String> requiredPermissions = [
    'Notifications',
    'Camera',
    'Location',
  ];
  
  // Error Messages
  static const String noConnectionError = '¡Ups! Something was wrong. Check your conexión.';
  static const String genericError = '¡Ups! Se presentó un error al realizar esta acción, inténtalo de nuevo.';
  static const String fieldRequiredError = 'Este campo es obligatorio.';
  static const String invalidPhoneError = 'El número no es válido.';
  static const String invalidEmailError = 'El correo no es válido.';
  static const String invalidCodeError = 'El código no es válido';
  static const String codeExpiredError = 'El código ha expirado. Inténtalo de nuevo.';
  static const String passwordMismatchError = 'Las contraseñas no coinciden.';
  static const String phoneAlreadyRegisteredError = 'El número ya se encuentra registrado';
  static const String minorAgeError = 'Se requiere ser mayor de 18 años.';
  static const String passwordRequirementsError = 'La contraseña debe tener al menos 8 caracteres incluyendo una mayúscula, una minúscula y un número.';
  
  // Success Messages
  static const String accountCreatedSuccess = 'Cuenta creada exitosamente';
  static const String passwordResetSuccess = 'Tu contraseña ha sido restablecida con éxito, ya puedes iniciar sesión nuevamente.';
  static const String codeResentSMSSuccess = 'Te hemos enviado un nuevo código de validación por SMS/OTP';
  static const String codeResentEmailSuccess = 'Te hemos enviado un nuevo correo de validación';
  
  // Info Messages
  static const String otpResendWaitMessage = 'Podrás reenviar el código en 30 s.';
  static const String verificationSMSTemplate = '¡Hola! Tu código de verificación en ForeverUSinlove es: {code}';
  
  // Routes (placeholder for future implementation)
  static const String splashRoute = '/splash';
  static const String welcomeRoute = '/welcome';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String homeRoute = '/home';
  static const String verifyIdentityRoute = '/verify-identity';
  static const String uploadImagesRoute = '/upload-images';
  static const String onboardingRoute = '/onboarding';
}
