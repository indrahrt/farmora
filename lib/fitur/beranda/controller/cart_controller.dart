import 'package:flutter/material.dart';
import '../../akun/models/product_model.dart';

class CartController extends ChangeNotifier {

  static final CartController instance = CartController._internal();

  factory CartController() {
    return instance;
  }

  CartController._internal();

  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  int get totalItem => _items.length;

  void addToCart(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

}
