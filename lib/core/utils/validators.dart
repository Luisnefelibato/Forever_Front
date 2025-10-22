import '../constants/app_constants.dart';

/// Utility class for input validation
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates if a string is not empty
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value) || value.length > AppConstants.emailMaxLength) {
      return AppConstants.invalidEmailError;
    }
    
    return null;
  }

  /// Validates Colombian phone number format (10 digits)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length != AppConstants.phoneNumberLength) {
      return AppConstants.invalidPhoneError;
    }
    
    return null;
  }

  /// Validates password requirements
  /// At least 8 characters, including uppercase, lowercase, and number
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    if (value.length < AppConstants.passwordMinLength || 
        value.length > AppConstants.passwordMaxLength) {
      return AppConstants.passwordRequirementsError;
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp('[A-Z]'))) {
      return AppConstants.passwordRequirementsError;
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp('[a-z]'))) {
      return AppConstants.passwordRequirementsError;
    }
    
    // Check for at least one digit
    if (!value.contains(RegExp('[0-9]'))) {
      return AppConstants.passwordRequirementsError;
    }
    
    return null;
  }

  /// Validates password confirmation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    if (value != originalPassword) {
      return AppConstants.passwordMismatchError;
    }
    
    return null;
  }

  /// Validates OTP code (4 digits)
  static String? otpCode(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length != AppConstants.otpCodeLength) {
      return AppConstants.invalidCodeError;
    }
    
    return null;
  }

  /// Validates name (alphanumeric, max 25 characters)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.fieldRequiredError;
    }
    
    if (value.length > AppConstants.nameMaxLength) {
      return 'El nombre no puede exceder ${AppConstants.nameMaxLength} caracteres.';
    }
    
    return null;
  }

  /// Validates age (must be 18 or older)
  static String? age(DateTime? birthDate) {
    if (birthDate == null) {
      return AppConstants.fieldRequiredError;
    }
    
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    final hasNotHadBirthdayThisYear = now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day);
    
    final actualAge = hasNotHadBirthdayThisYear ? age - 1 : age;
    
    if (actualAge < AppConstants.minimumAge) {
      return AppConstants.minorAgeError;
    }
    
    return null;
  }

  /// Validates max length
  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'El texto no puede exceder $maxLength caracteres.';
    }
    return null;
  }
}
