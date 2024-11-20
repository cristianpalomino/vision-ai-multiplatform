import '../utils/secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  final _storage = SecureStorage();

  Future<Map<String, String>> get headers async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> get multipartHeaders async {
    final token = await _storage.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
