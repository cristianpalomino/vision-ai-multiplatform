import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    try {
      await _storage.write(key: 'jwt_token', value: token);
    } catch (e) {
      throw Exception('Failed to store token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'jwt_token');
    } catch (e) {
      throw Exception('Failed to read token: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      throw Exception('Failed to delete token: $e');
    }
  }
}
