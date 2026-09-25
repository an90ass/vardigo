import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


abstract final class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyToken = 'auth_token';
  static const String _keyRole = 'user_role';

  // In-memory fallback
  static String? _memoryToken;
  static String? _memoryRole;

  static Future<void> saveToken(String token) async {
    _memoryToken = token;
    try {
      await _storage.write(key: _keyToken, value: token);
    } catch (e) {
      debugPrint('[TokenStorage] Secure storage write warning (using memory fallback): $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _keyToken);
      return token ?? _memoryToken;
    } catch (e) {
      debugPrint('[TokenStorage] Secure storage read warning (using memory fallback): $e');
      return _memoryToken;
    }
  }

  static Future<void> saveRole(String role) async {
    _memoryRole = role;
    try {
      await _storage.write(key: _keyRole, value: role);
    } catch (e) {
      debugPrint('[TokenStorage] Secure storage write warning (using memory fallback): $e');
    }
  }

  static Future<String?> getRole() async {
    try {
      final role = await _storage.read(key: _keyRole);
      return role ?? _memoryRole;
    } catch (e) {
      debugPrint('[TokenStorage] Secure storage read warning (using memory fallback): $e');
      return _memoryRole;
    }
  }

  static Future<void> clear() async {
    _memoryToken = null;
    _memoryRole = null;
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('[TokenStorage] Secure storage clear warning: $e');
    }
  }
}
