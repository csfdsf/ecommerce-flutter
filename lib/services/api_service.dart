import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';


class ApiService {
  static const String _apiUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Check Your Internet Connection: $error');
    }
  }
}
