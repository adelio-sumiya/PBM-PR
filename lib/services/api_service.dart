import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = (await _authService.getToken())?.trim();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Product>> getProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List dynamicList = data['data'] ?? data;
        return dynamicList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      debugPrint('Get products error: $e');
      return [];
    }
  }

  Future<bool> addProduct(String name, int price, String description) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Add product error: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Delete product error: $e');
      return false;
    }
  }

  Future<bool> submitTask({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products/submit'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Submit task error: $e');
      return false;
    }
  }
}
