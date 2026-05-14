import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final AuthService _authService = AuthService();

  // Helper method to generate the required headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Fetch all products
  Future<List<Product>> getProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the list is in a 'data' field or is the direct response
        final List dynamicList = data['data'] ?? data;
        return dynamicList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Get products error: $e');
      return [];
    }
  }

  // Add a new product
  Future<bool> addProduct(String name, double price, String description) async {
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
      print('Add product error: $e');
      return false;
    }
  }

  // Delete a product (Soft delete per requirement)
  Future<bool> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  // Submit the final task
  Future<bool> submitTask(String githubLink) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/products/submit'),
        headers: headers,
        body: jsonEncode({
          'github_link': githubLink,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Submit task error: $e');
      return false;
    }
  }
}
