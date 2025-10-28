/// Social Authentication Configuration
/// 
/// IMPORTANT: Replace these values with your actual credentials from:
/// - Google Cloud Console (for Google Sign-In)
/// - Facebook Developer Console (for Facebook Login)
class SocialAuthConfig {
  // Google Configuration
  static const String googleClientId = '123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com';
  static const String googleWebClientId = '123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com';
  
  // Facebook Configuration
  static const String facebookAppId = '1234567890123456';
  static const String facebookClientToken = 'abcdef1234567890abcdef1234567890';
  
  // Instructions for getting real credentials:
  
  /// Google Sign-In Setup:
  /// 1. Go to Google Cloud Console (https://console.cloud.google.com/)
  /// 2. Create a new project or select existing one
  /// 3. Enable Google+ API and Google Sign-In API
  /// 4. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
  /// 5. Select "Android" as application type
  /// 6. Enter your package name: com.example.forever_us_in_love
  /// 7. Get your SHA-1 fingerprint: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  /// 8. Copy the Client ID and replace googleClientId above
  /// 9. Download google-services.json and replace the one in android/app/
  
  /// Facebook Login Setup:
  /// 1. Go to Facebook Developer Console (https://developers.facebook.com/)
  /// 2. Create a new app or select existing one
  /// 3. Add "Facebook Login" product
  /// 4. Go to "Settings" → "Basic"
  /// 5. Copy App ID and replace facebookAppId above
  /// 6. Copy App Secret and replace facebookClientToken above
  /// 7. Add your package name: com.example.forever_us_in_love
  /// 8. Add your SHA-1 fingerprint (same as Google)
  /// 9. Update strings.xml with your Facebook App ID
  
  /// Additional Steps:
  /// 1. Update android/app/google-services.json with your Firebase project
  /// 2. Update android/app/src/main/res/values/strings.xml with your Facebook App ID
  /// 3. Make sure your backend supports Google and Facebook authentication
  /// 4. Test on a real device (not emulator) for best results
}
