import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtal_store/datas/cart_products.dart';
import 'package:virtal_store/datas/result_cep.dart';
import 'package:virtal_store/models/user_model.dart';

class CartModel extends Model {
  late UserModel user;

  List<CartProduct> products = [];

  bool isLoading = false;
  String cupomCode = "";
  int discountPercentage = 0;
  String typePayment = "";

  CartModel(this.user) {
    if (user.isLoadingIn()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartitem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removeCartitem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void degrementItem(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void ingrementItem(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
  }

  void setCupom(String cupomCode, int discountPercentage) {
    this.cupomCode = cupomCode;
    this.discountPercentage = discountPercentage;
  }

  void typePay(String pay) {
    typePayment = pay;
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      // ignore: unnecessary_null_comparison
      if (c.productsData != null) {
        price = c.quantity * c.productsData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  bool loading() {
    return isLoading;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOder() async {
    if (products.isEmpty) return "Null";

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    ResultCep resultCep = ResultCep(
        cep: "",
        logradouro: " logradouro",
        complemento: "complemento",
        bairro: "bairro",
        localidade: "localidade",
        uf: "uf",
        ibge: "ibge",
        gia: "");

    DocumentReference refOder =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user.usuario!.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "discount": discount,
      "totalPrice": productsPrice + shipPrice - discount,
      "status": 1,
      "typePayment": typePayment,
      "address": resultCep.toResumedMap(),
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("orders")
        .doc(refOder.id)
        .set({"orderId": refOder.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.usuario!.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }
    products.clear();
    cupomCode = "";
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOder.id;
  }
}
