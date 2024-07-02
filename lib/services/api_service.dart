import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.kartel.dev';

  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<bool> postProduct(String name, num price, num qty, String attr, num weight) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        'issuer': 'jalal',
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add product');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  static Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  static Future<List<dynamic>> fetchstocks() async {
    final response = await http.get(Uri.parse('$_baseUrl/stocks'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  static Future<bool> poststock(String name, num qty, String attr, num weight) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/stocks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        'issuer': 'jalal',
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add stock');
    }
  }

  static Future<void> deletestock(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/stocks/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete stock');
    }
  }

  static Future<void> updatestock(String id, Map<String, dynamic> stock) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/stocks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(stock),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update stock');
    }
  }

  static Future<List<dynamic>> fetchsales() async {
    final response = await http.get(Uri.parse('$_baseUrl/sales'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sales');
    }
  }

  static Future<bool> postsale(String buyer, String phone, String date, String status) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
        'issuer': 'jalal',
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add sale');
    }
  }

  static Future<void> deletesale(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/sales/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale');
    }
  }

  static Future<void> updatesale(String id, Map<String, dynamic> sale) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/sales/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sale),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update sale');
    }
  }
}
