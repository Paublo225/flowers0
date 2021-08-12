import '../model/product.dart';
import '../sevices/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];

  ProductProvider.initialize() {
    loadProducts();
  }

  loadProducts() async {
    products = await _productServices.getProducts();
    notifyListeners();
  }
}
