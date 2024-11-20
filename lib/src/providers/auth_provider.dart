import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<String?>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<String?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  final _storage = SecureStorage();
  final _authService = AuthService();

  Future<void> _init() async {
    try {
      final token = await _storage.getToken();
      state = AsyncValue.data(token);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String uuid, String password) async {
    try {
      state = const AsyncValue.loading();
      final token = await _authService.login(uuid, password);
      await _storage.storeToken(token);
      state = AsyncValue.data(token);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(String uuid, String password) async {
    try {
      state = const AsyncValue.loading();
      await _authService.register(uuid, password);
      // After registration, automatically login
      await login(uuid, password);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    state = const AsyncValue.data(null);
  }
}
