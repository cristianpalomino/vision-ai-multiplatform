import 'package:vision_ai_multiplatform/src/models/user_model.dart';
import 'package:vision_ai_multiplatform/src/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ApiService {
  Future<String> login(String uuid, String password) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/user/login'),
      headers: await headers,
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

  Future<String> register(String uuid, String password) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/user/register'),
      headers: await headers,
      body: jsonEncode({
        'uuid': uuid,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    
    if (response.statusCode == 201) {
      return data['message'] ?? 'Registration successful';
    }
    
    throw Exception(data['message'] ?? 'Failed to register');
  }

  Future<User> getProfile() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/user/profile'),
      headers: await headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    throw Exception('Failed to load profile');
  }
}
