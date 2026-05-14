import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Method to handle login
  Future<bool> login(String nim) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': nim,
          'password': nim, // As per requirements, password is the NIM
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the token is returned in a field named 'token'
        final String token = data['token'] ?? data['data']?['token'] ?? '';
        
        if (token.isNotEmpty) {
          // Save the token securely for future API requests
          await _storage.write(key: 'auth_token', value: token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Method to check if user is logged in (has token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Method to retrieve the saved token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Method to handle logout by deleting the token
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
