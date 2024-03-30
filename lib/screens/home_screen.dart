import 'package:flutter/material.dart';
import 'package:virtal_store/tabs/orders_tab.dart';
import 'package:virtal_store/widgets/cart_button.dart';
import '../tabs/home_tab.dart';
import '../tabs/places_tab.dart';
import '../tabs/products_tab.dart';
import '../widgets/custon_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          drawer: CustonDrawer(
            pageController: _pageController,
          ),
          body: const HomeTab(),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 214, 21, 125),
            title: const Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustonDrawer(
            pageController: _pageController,
          ),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Nossas lojas"),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 214, 21, 125),
          ),
          drawer: CustonDrawer(
            pageController: _pageController,
          ),
          body: const PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Meus Pedidos"),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 214, 21, 125),
          ),
          drawer: CustonDrawer(
            pageController: _pageController,
          ),
          body: const OrdersTab(),
        ),
      ],
    );
  }
}
