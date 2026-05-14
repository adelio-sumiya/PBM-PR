import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'] ?? data['data']?['token'] ?? '';

        if (token.trim().isNotEmpty) {
          await _storage.write(key: 'auth_token', value: token.trim());
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
