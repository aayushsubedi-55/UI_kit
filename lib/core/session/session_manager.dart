import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Single source of truth for the auth token. Backed by secure storage so
/// it survives app restarts but never touches plain prefs.
class SessionManager {
  SessionManager({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  String? _cachedToken;

  Future<String?> getToken() async {
    return _cachedToken ??= await _storage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clear() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> get isLoggedIn async => (await getToken()) != null;
}
