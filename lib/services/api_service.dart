import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/auth_response.dart';

class ApiService {
  static const String baseUrl = 'https://cabinet.adelipnz.ru/api';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future <AuthResponse> login(String login, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': login,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse(
          success: false,
          message: 'Ошибка сервера: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Ошибка подключения: $e',
      );
    }
  }

  Future<AuthResponse> getUserProfile(String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse(
          success: false,
          message: 'Ошибка получения профиля: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Ошибка подключения: $e',
      );
    }
  }

  Future<bool> logout(String token) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}