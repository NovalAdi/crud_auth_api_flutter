import 'dart:convert';
import 'dart:developer';

import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:crud_api_app/models/product.dart';
import 'package:http/http.dart' as http;

import '../constants/api_config.dart';

class ProductService {
  ProductService._();

  static Future<List<Product>?> getProducts() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}';
      final token = await SecureStorage.getToken();

      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final List listDataJson = responseJson['data'];
          List<Product> products = [];
          for (final json in listDataJson) {
            products.add(Product.fromJson(json));
          }
          return products;
        }
      }
    } catch (e) {
      log('Error get Products $e');
      return null;
    }
  }

  static Future<void> createProduct({
    required String name,
    required String price,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}';
      final Map<String, dynamic> body = {
        'name': name,
        'price': price,
      };
      final token = await SecureStorage.getToken();
      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: header,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {}
      }
    } catch (e, st) {
      log('Error createProduct : $e\nStacktrace : $st');
    }
  }

  static Future<void> updateProduct({
    required int id,
    required String name,
    required String price,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}/$id';
      final Map body = {
        "name": name,
        "price": price,
      };
      final token = await SecureStorage.getToken();
      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: header,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {}
      }
    } catch (e) {
      log('Error updateProduct $e');
    }
  }

  static Future<void> deleteProduct(int id) async {
    try {
      final url =
          '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}/delete/$id';
      final token = await SecureStorage.getToken();
      log(token.toString());
      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse(url), headers: header);
      log('${response.body}');
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {}
      }
    } catch (e) {
      log('Error deleteProduct : $e');
    }
  }
}
