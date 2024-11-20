import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/secure_storage.dart';
import 'package:meta/meta.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => statusCode != null
      ? 'ApiException: $message (Status: $statusCode)'
      : 'ApiException: $message';
}

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  final _client = http.Client();
  final _cancelTokens = <String, CancelToken>{};
  final _secureStorage = SecureStorage();

  @protected
  http.Client get client => _client;

  Future<Map<String, String>> get headers async {
    final token = await _secureStorage.getToken();
    if (token == null) {
      throw const ApiException('No authentication token found');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> get multipartHeaders async {
    final token = await _secureStorage.getToken();
    if (token == null) {
      throw const ApiException('No authentication token found');
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<T> makeRequest<T>({
    required String path,
    required String method,
    required T Function(http.Response) parser,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? cancelKey,
    bool requiresAuth = true,
  }) async {
    final uri =
        Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);
    final request = http.Request(method, uri);

    try {
      request.headers.addAll(requiresAuth
          ? await headers
          : {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            });

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final cancelToken = _createCancelToken(cancelKey);
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (cancelToken?.isCancelled ?? false) {
        throw const CancelledException();
      }

      if (response.statusCode == 401 && requiresAuth) {
        await _secureStorage.deleteToken();
        throw const ApiException('Authentication failed', 401);
      }

      return parser(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Request failed: $e');
    } finally {
      if (cancelKey != null) {
        _cancelTokens.remove(cancelKey);
      }
    }
  }

  CancelToken? _createCancelToken(String? key) {
    if (key == null) return null;

    final token = CancelToken();
    _cancelTokens[key] = token;
    return token;
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
