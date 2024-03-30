import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/tiles/category_tile.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';

// ProductsTab é posição 1 da Drawer, nela é recuperado as informações da colleção
//"products" no firebase e exibida em forma de lista, gerando uma lista de categoria
//de produtos.
class ProductsTab extends StatelessWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularIndicator();
        } else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data!.docs.map((doc) {
                    return CategoryTile(snapshot: doc);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
