import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/models/cart_model.dart';

class DiscountCart extends StatelessWidget {
  const DiscountCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Cupom de descontos",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Informe seu cupon"),
              initialValue: CartModel.of(context).cupomCode,
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("cupoms")
                    .doc(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data() != null) {
                    CartModel.of(context).setCupom(text, docSnap["percent"]);
                    ScaffoldMessenger.of(context)
                        // ignore: deprecated_member_use
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                            "Desconto de ${docSnap["percent"]}% aplicado."),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    CartModel.of(context).setCupom("", 0);
                   ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cupom invalido!"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
