import 'package:cloud_firestore/cloud_firestore.dart';

// CLASSE ULTILIZADA PARA ARMAZENAR E CONVERTES OS ITEM RECUPERADO DO FIRE BASE
// É BOM MANTER ELA, POIS FACILITA CASO PRECISE TROCAR O BANCO DE DADOS.
class ProductsData {
  late String id;
  late String title;
  late String description;
  late String category;
  late double price = 0.0;
  late List size;
  late List images;

  ProductsData();

  ProductsData.fromDocuments(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot["title"];
    description = snapshot["description"];
    price = snapshot["price"] + 0.0;
    images = snapshot["images"];
    size = snapshot["size"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
