import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtal_store/datas/products_data.dart';

class CartProduct {
  late String cid;
  late String category;
  late String pid;
  late int quantity;
  late String size;

  ProductsData productsData = ProductsData();
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document["category"];
    pid = document["pid"];
    quantity = document["quantity"];
    size = document["size"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productsData.toResumedMap(),
    };
  }
}
