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

      if (_isSuccessStatus(response.statusCode)) {
        final data = jsonDecode(response.body);
        final dynamicList = _extractProductList(data);
        return dynamicList
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      debugPrint('Get products error: $e');
      return [];
    }
  }

  List<dynamic> _extractProductList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      for (final key in ['data', 'products', 'items', 'records']) {
        final value = data[key];
        if (value is List) return value;
        if (value is Map<String, dynamic>) {
          final nestedList = _extractProductList(value);
          if (nestedList.isNotEmpty) return nestedList;
        }
      }
    }

    return [];
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

      final success = _isSuccessStatus(response.statusCode);
      if (!success) {
        debugPrint(
          'Add product failed: ${response.statusCode} ${response.body}',
        );
      }
      return success;
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

      final success = _isSuccessStatus(response.statusCode);
      if (!success) {
        debugPrint(
          'Delete product failed: ${response.statusCode} ${response.body}',
        );
      }
      return success;
    } catch (e) {
      debugPrint('Delete product error: $e');
      return false;
    }
  }

  Future<bool> submitTask(String githubUrl) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products/submit'),
        headers: headers,
        body: jsonEncode({'github_url': githubUrl}),
      );

      final success = _isSuccessStatus(response.statusCode);
      if (!success) {
        debugPrint(
          'Submit task failed: ${response.statusCode} ${response.body}',
        );
      }
      return success;
    } catch (e) {
      debugPrint('Submit task error: $e');
      return false;
    }
  }

  bool _isSuccessStatus(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }
}
