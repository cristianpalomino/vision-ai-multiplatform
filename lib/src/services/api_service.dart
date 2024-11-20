import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  final _client = http.Client();
  final _cancelTokens = <String, CancelToken>{};

  Future<Map<String, String>> get headers async {
    final token = await SecureStorage().getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> get multipartHeaders async {
    final token = await SecureStorage().getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<T> makeRequest<T>({
    required String path,
    required String method,
    required T Function(http.Response) parser,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? cancelKey,
  }) async {
    final uri =
        Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);
    final request = http.Request(method, uri);

    if (body != null) {
      request.headers.addAll(await headers);
      request.body = jsonEncode(body);
    }

    final cancelToken = CancelToken();
    if (cancelKey != null) {
      _cancelTokens[cancelKey] = cancelToken;
    }

    try {
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (cancelToken.isCancelled) {
        throw const CancelledException();
      }

      return parser(response);
    } finally {
      if (cancelKey != null) {
        _cancelTokens.remove(cancelKey);
      }
    }
  }

  void cancelRequest(String key) {
    _cancelTokens[key]?.cancel();
    _cancelTokens.remove(key);
  }

  void dispose() {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    _client.close();
  }
}

class CancelToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  void cancel() {
    _isCancelled = true;
  }
}

class CancelledException implements Exception {
  const CancelledException();

  @override
  String toString() => 'Request was cancelled';
}
