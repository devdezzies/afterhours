import 'package:afterhours/core/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> readToken() =>
      _storage.read(key: AppConstants.keyAuthToken);

  static Future<void> writeToken(String token) =>
      _storage.write(key: AppConstants.keyAuthToken, value: token);

  static Future<void> deleteToken() =>
      _storage.delete(key: AppConstants.keyAuthToken);
}
