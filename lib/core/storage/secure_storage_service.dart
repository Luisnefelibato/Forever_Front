import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Secure storage service for sensitive data
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // ============================================================================
  // Token Management
  // ============================================================================

  /// Save authentication token
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
      if (kDebugMode) {
        print('💾 Token saved to secure storage');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving token: $e');
      }
      rethrow;
    }
  }

  /// Get authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error reading token: $e');
      }
      return null;
    }
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: 'auth_token');
      if (kDebugMode) {
        print('🗑️ Token cleared from secure storage');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing token: $e');
      }
      rethrow;
    }
  }

  /// Check if user is authenticated (has token)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============================================================================
  // User Data Management
  // ============================================================================

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  /// Save user phone
  Future<void> saveUserPhone(String phone) async {
    await _storage.write(key: 'user_phone', value: phone);
  }

  /// Get user phone
  Future<String?> getUserPhone() async {
    return await _storage.read(key: 'user_phone');
  }

  // ============================================================================
  // Remember Me Functionality
  // ============================================================================

  /// Save remember me preference
  Future<void> saveRememberMe(bool remember) async {
    await _storage.write(key: 'remember_me', value: remember.toString());
  }

  /// Get remember me preference
  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: 'remember_me');
    return value == 'true';
  }

  /// Save last login identifier (email/phone)
  Future<void> saveLastLogin(String identifier) async {
    await _storage.write(key: 'last_login', value: identifier);
  }

  /// Get last login identifier
  Future<String?> getLastLogin() async {
    return await _storage.read(key: 'last_login');
  }

  // ============================================================================
  // Clear All Data
  // ============================================================================

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      if (kDebugMode) {
        print('🗑️ All secure data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing all data: $e');
      }
      rethrow;
    }
  }
}
