import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://3.110.132.121'; 
  
  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Product-specific methods
  static Future<List<Product>> getProducts() async {
    final data = await get('/products');
    final List<dynamic> productsJson = data['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> getProduct(String id) async {
    final data = await get('/products/$id');
    return Product.fromJson(data);
  }

  static Future<Product> createProduct(Product product) async {
    final data = await post('/products', product.toJson());
    return Product.fromJson(data);
  }
} 