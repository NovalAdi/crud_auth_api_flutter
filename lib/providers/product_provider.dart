import 'package:crud_api_app/services/product_service.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Product> _products = [];
  List<Product> get products => _products;
  Future<void> getProducts() async {
    _setLoading(() async {
      final response = await ProductService.getProducts();
      if (response != null) {
        _products = response;
      }
    });
  }

  Future<void> createProduct({
    required String name,
    required String price,
  }) async {
    _setLoading(() async {
      await ProductService.createProduct(
        name: name,
        price: price,
      );
    });
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String price,
  }) async {
    _setLoading(() async {
      await ProductService.updateProduct(
        id: id,
        name: name,
        price: price,
      );
    });
  }

  Future<void> deleteProduct({
    required int id,
  }) async {
    _setLoading(() async {
      await ProductService.deleteProduct(id);
    });
  }

  void _setLoading(void Function() process) {
    isLoading = true;
    notifyListeners();

    process();
    isLoading = false;
    notifyListeners();
  }
}
