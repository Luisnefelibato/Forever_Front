import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables
class AppConfig {
  // API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get apiTimeout => dotenv.env['API_TIMEOUT'] ?? '30000';
  
  // AWS Configuration
  static String get awsRegion => dotenv.env['AWS_REGION'] ?? '';
  static String get awsAccessKeyId => dotenv.env['AWS_ACCESS_KEY_ID'] ?? '';
  static String get awsSecretAccessKey => dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? '';
  static String get awsS3BucketName => dotenv.env['AWS_S3_BUCKET_NAME'] ?? '';
  static String get awsCognitoUserPoolId => dotenv.env['AWS_COGNITO_USER_POOL_ID'] ?? '';
  static String get awsCognitoClientId => dotenv.env['AWS_COGNITO_CLIENT_ID'] ?? '';
  
  // Firebase Configuration
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  
  // OAuth Configuration
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get facebookAppId => dotenv.env['FACEBOOK_APP_ID'] ?? '';
  
  // Feature Flags
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  
  // Environment
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
}
