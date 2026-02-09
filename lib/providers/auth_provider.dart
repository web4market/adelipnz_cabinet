import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  final ApiService _apiService;
  final StorageService _storageService;

  AuthProvider(this._apiService, this._storageService);

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

      if (_token != null && userData != null) {
        // Получаем актуальные данные пользователя
        final response = await _apiService.getUserProfile(_token!);
        if (response.success && response.user != null) {
          _user = response.user;
          _error = null;
        } else {
          await logout();
        }
      }
    } catch (e) {
      _error = 'Ошибка инициализации: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String login, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(login, password);

      if (response.success && response.token != null && response.user != null) {
        _token = response.token;
        _user = response.user;

        // Сохраняем данные
        await _storageService.saveAuthData(
          _token!,
          response.user!.toJson().toString(),
        );

        _error = null;
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = 'Ошибка входа: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _apiService.logout(_token!);
      }
    } catch (e) {
      print('Ошибка при выходе: $e');
    } finally {
      _user = null;
      _token = null;
      _error = null;
      await _storageService.clearAuthData();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}