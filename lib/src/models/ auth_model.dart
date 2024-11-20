import 'package:vision_ai_multiplatform/src/models/user_model.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class AuthRequest {
  final String uuid;
  final String password;

  AuthRequest({
    required this.uuid,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'password': password,
      };
}
