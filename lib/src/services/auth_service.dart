import 'package:vision_ai_multiplatform/src/models/user_model.dart';
import 'package:vision_ai_multiplatform/src/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AuthService extends ApiService {
  // Store active requests to cancel them if needed
  final _httpClient = http.Client();

  Future<String> login(String uuid, String password) async {
    final completer = Completer<String>();
    final request =
        http.Request('POST', Uri.parse('${ApiService.baseUrl}/user/login'))
          ..headers.addAll(await headers)
          ..body = jsonEncode({
            'uuid': uuid,
            'password': password,
          });

    final streamedResponse = await _httpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      completer.complete(token);
    } else {
      completer.completeError('Failed to login');
    }

    return completer.future;
  }

  Future<String> register(String uuid, String password) async {
    try {
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
        return 'Registration successful';
      }

      // Return user-friendly error message instead of raw server message
      switch (response.statusCode) {
        case 400:
          throw Exception('Invalid registration details provided');
        case 409:
          throw Exception('User already exists');
        case 500:
          throw Exception('An error occurred during registration');
        default:
          throw Exception('Registration failed. Please try again later');
      }
    } catch (e) {
      throw Exception(
          'Unable to complete registration. Please try again later');
    }
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

  // Add dispose method to cleanup
  void dispose() {
    _httpClient.close();
  }
}
