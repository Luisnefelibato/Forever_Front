# Social Authentication Setup Guide

This guide will help you configure Google and Facebook authentication for your Flutter app.

## Prerequisites

- Google Cloud Console account
- Facebook Developer account
- Android Studio with Flutter SDK
- A real Android device for testing (emulators may have issues)

## Google Sign-In Setup

### Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Google+ API
   - Google Sign-In API
   - Firebase Authentication API

### Step 2: Configure OAuth 2.0

1. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
2. Select "Android" as application type
3. Enter your package name: `com.example.forever_us_in_love`
4. Get your SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Copy the Client ID

### Step 3: Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add Android app with package name: `com.example.forever_us_in_love`
4. Download `google-services.json`
5. Replace the file in `android/app/google-services.json`

### Step 4: Update Configuration

1. Update `lib/core/config/social_auth_config.dart` with your Google Client ID
2. Update `android/app/google-services.json` with your Firebase project

## Facebook Login Setup

### Step 1: Create Facebook App

1. Go to [Facebook Developer Console](https://developers.facebook.com/)
2. Create a new app or select existing one
3. Add "Facebook Login" product
4. Configure Facebook Login settings

### Step 2: Configure Android Settings

1. Go to "Settings" → "Basic"
2. Copy App ID and App Secret
3. Add your package name: `com.example.forever_us_in_love`
4. Add your SHA-1 fingerprint (same as Google)

### Step 3: Update Configuration

1. Update `lib/core/config/social_auth_config.dart` with your Facebook App ID
2. Update `android/app/src/main/res/values/strings.xml` with your Facebook App ID
3. Update `android/app/src/main/AndroidManifest.xml` if needed

## Backend Configuration

Make sure your backend supports Google and Facebook authentication:

1. **Google**: Accept ID tokens and verify them
2. **Facebook**: Accept access tokens and verify them
3. **User Creation**: Create user accounts from social login data
4. **Token Management**: Handle JWT tokens for authenticated sessions

## Testing

1. **Use Real Device**: Test on a real Android device, not emulator
2. **Check Logs**: Monitor console logs for authentication errors
3. **Verify Backend**: Ensure backend endpoints are working
4. **Test Flow**: Complete the full authentication flow

## Troubleshooting

### Common Issues

1. **MissingPluginException**: Plugin not properly configured
   - Solution: Check Android configuration files

2. **ApiException: 10**: Google Sign-In not configured
   - Solution: Verify google-services.json and SHA-1 fingerprint

3. **Facebook Login Failed**: Facebook app not configured
   - Solution: Check Facebook App ID and package name

4. **Backend Errors**: Server doesn't support social auth
   - Solution: Implement backend social authentication

### Debug Steps

1. Check Android logs: `flutter logs`
2. Verify configuration files
3. Test on real device
4. Check backend logs
5. Verify SHA-1 fingerprint

## Security Notes

- Never commit real credentials to version control
- Use environment variables for production
- Implement proper token validation on backend
- Use HTTPS for all API calls
- Validate user data from social providers

## Production Checklist

- [ ] Replace all test credentials with real ones
- [ ] Configure production Firebase project
- [ ] Set up proper error handling
- [ ] Implement user data validation
- [ ] Test on multiple devices
- [ ] Configure proper logging
- [ ] Set up monitoring and analytics
