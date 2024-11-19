import 'package:vision_ai_multiplatform/src/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ApiService {
  Future<String> login(String uuid, String password) async {
    final response = await http.post(
      Uri.parse('$ApiService.baseUrl/user/login'),
      headers: headers,
      body: jsonEncode({
        'uuid': uuid,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      return token;
    }
    throw Exception('Failed to login');
  }

  Future<void> register(String uuid, String password) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/user/register'),
      headers: headers,
      body: jsonEncode({
        'uuid': uuid,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }
}
