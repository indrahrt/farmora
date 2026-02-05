import 'package:flutter/material.dart';
import '../models/keranjang_model.dart';
import '../../akun/models/product_model.dart';

class CartController extends ChangeNotifier {
  // ================= SINGLETON =================
  static final CartController instance = CartController._internal();
  factory CartController() => instance;
  CartController._internal();

  // ================= DATA =================
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  // ================= BADGE CART =================
  int get totalItem {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // ================= CEK PRODUK =================
  bool isProductInCart(ProductModel product) {
    return _items.any(
      (item) =>
          item.product.name == product.name &&
          item.product.ownerId == product.ownerId,
    );
  }

  // ================= TAMBAH KE CART =================
  void addToCart(ProductModel product) {
    final index = _items.indexWhere(
      (item) =>
          item.product.name == product.name &&
          item.product.ownerId == product.ownerId,
    );

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItemModel(product: product));
    }

    notifyListeners();
  }

  // ================= QTY =================
  void increaseQty(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQty(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  // ================= CHECKBOX =================
  void toggleItem(int index, bool value) {
    _items[index].selected = value;
    notifyListeners();
  }

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((e) => e.selected);

  void toggleSelectAll(bool value) {
    for (var item in _items) {
      item.selected = value;
    }
    notifyListeners();
  }

  // ================= HAPUS ITEM =================
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  // ================= TOTAL PRICE =================
  int get totalPrice {
    return _items
        .where((e) => e.selected)
        .fold(0, (sum, e) => sum + e.product.price * e.quantity);
  }

  // ================= RESET CART =================
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
