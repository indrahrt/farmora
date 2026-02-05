import 'package:flutter/material.dart';
import '../controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Troli")),
      body: AnimatedBuilder(
        animation: cart,
        builder: (_, __) {
          if (cart.items.isEmpty) {
            return const Center(child: Text("Troli kosong"));
          }

          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final product = cart.items[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text("Rp ${product.price}"),
              );
            },
          );
        },
      ),
    );
  }
}
