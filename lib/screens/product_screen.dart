import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/datas/cart_products.dart';
import 'package:virtal_store/datas/products_data.dart';
import 'package:virtal_store/models/cart_model.dart';
import 'package:virtal_store/models/user_model.dart';
import 'package:virtal_store/screens/cart_screen.dart';
import 'package:virtal_store/screens/login_screen.dart';
// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key, required this.data}) : super(key: key);

  final ProductsData data;

  String size = "";
  String typePayment = "";
  Map<String, dynamic> userdata = {};
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 214, 21, 125),
        title: Text(widget.data.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CarouselSlider(
              items: widget.data.images.map((url) {
                return Builder(
                  builder: (context) {
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
              options:
                  CarouselOptions(height: MediaQuery.of(context).size.height),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.data.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  "R\$ ${widget.data.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Temanho",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 36,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.5),
                    children: widget.data.size.map((optionSize) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.size = optionSize;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                                color: optionSize == widget.size
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                width: 3),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(optionSize),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: widget.size != ""
                        ? () async {
                            if (UserModel.of(context).isLoadingIn()) {
                              CartProduct cartProduct = CartProduct();

                              cartProduct.size = widget.size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = widget.data.id;
                              cartProduct.category = widget.data.category;
                              cartProduct.productsData = widget.data;

                              CartModel.of(context).addCartitem(cartProduct);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen(
                                        data: widget.data,
                                      )));
                            } else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoadingIn()
                          ? "Adicionar ao carrinho"
                          : "Entre para comprar",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Descrição",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.data.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
