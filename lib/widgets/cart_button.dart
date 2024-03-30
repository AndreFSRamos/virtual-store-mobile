import 'package:flutter/material.dart';
import 'package:virtal_store/datas/products_data.dart';
import 'package:virtal_store/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        ProductsData productsData = ProductsData();
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CartScreen(data: productsData)),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
