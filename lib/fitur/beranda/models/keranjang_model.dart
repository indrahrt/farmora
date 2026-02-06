import '../../akun/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  bool selected;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selected = true,
  });
}
