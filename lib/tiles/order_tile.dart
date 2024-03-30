import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularIndicator();
            } else {
              int status = snapshot.data!["status"];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Código do pedido : ${snapshot.data!.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  //  Text(snapshot.toString()),
                  Text(_buildProductsText(snapshot.data!)),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Status do Pedido",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircle("1", "Preparação", status, 1, context),
                      Container(
                        height: 1,
                        width: 40,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("2", "Trasnporte", status, 2, context),
                      Container(
                        height: 1,
                        width: 40,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("3", "Entrega", status, 3, context),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap p in snapshot["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"]})\n";

      // "${p["quantity"]}";
    }
    text += "Total: R\$ ${snapshot["totalPrice"]}";
    return text;
  }

  Widget _buildCircle(String tiele, String subtitle, int status, int thisStatus,
      BuildContext context) {
    late Color? background;
    late Widget child;

    if (status < thisStatus) {
      background = Colors.grey[500];
      child = Text(
        tiele,
        style: const TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      background = Theme.of(context).primaryColor;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            tiele,
            style: const TextStyle(color: Colors.white),
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      background = Colors.green;
      child = const Icon(
        Icons.check,
        color: Colors.white,
        size: 28,
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: background,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
