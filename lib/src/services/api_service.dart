class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  final String? token;

  ApiService({this.token});

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Map<String, String> get multipartHeaders => {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
}
