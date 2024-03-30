import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtal_store/models/cart_model.dart';

class CartPrice extends StatelessWidget {
  CartPrice({Key? key, required this.buy}) : super(key: key);

  VoidCallback buy;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double price = model.getProductsPrice();
            double ship = model.getShipPrice();
            double discount = model.getDiscount();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Resumo do Pedido.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal: "),
                    Text("R\$ ${price.toStringAsFixed(2)}")
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Desconto: "),
                    Text("R\$ ${discount.toStringAsFixed(2)}")
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Entrega: "),
                    Text("R\$ ${ship.toStringAsFixed(2)}")
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ignore: deprecated_member_use
                ElevatedButton(
                  onPressed: buy,
                  child: const Text("Finalizar Pedido"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
