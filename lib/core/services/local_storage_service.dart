import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over [SharedPreferences] for non-sensitive local data
/// (feature flags, "seen onboarding", cached settings, ...). For secrets
/// use [SessionManager] instead.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> create() async {
    return LocalStorageService(await SharedPreferences.getInstance());
  }

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> remove(String key) => _prefs.remove(key);
}
