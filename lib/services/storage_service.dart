import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  StorageService(this._prefs, this._secureStorage);

  Future<void> saveAuthData(String token, String userData) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    await _prefs.setString(_userKey, userData);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<String?> getUserData() async {
    return _prefs.getString(_userKey);
  }

  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _tokenKey);
    await _prefs.remove(_userKey);
  }

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();
    return StorageService(prefs, secureStorage);
  }
}