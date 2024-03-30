import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/datas/products_data.dart';
import 'package:virtal_store/tiles/products_tile.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';

//CategoryScreen é responsavel por exibir cada item da categoria, em forma de Grid
// ou lisa, ela recebe por parametro as informações da categoria escolhida em
//formar de snapshot.

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    //================== INICIO DA APPBAR ====================================
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 214, 21, 125),
          title: Text(snapshot["title"]),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        //================= INICIO DO CORPO DA PAGE ================================
        body: FutureBuilder<QuerySnapshot>(
          //Recupera as informaçãoes da coleção "items" que está detro da coleção "products".
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(snapshot.id)
              .collection("items")
              .get(),
          builder: (context, snapshot) {
            //Verificando a snapshot e diferente de vazio, caso SIM ele apresenta um icone animado
            //indicando que está aguardando um resposta. Caso contrario, exibir a lista dos items
            // em forma de GRID ou LIST.
            if (!snapshot.hasData) {
              return const CircularIndicator();
            } else {
              //======= INICIO DA CONSRUÇÃO DA GRID ========================================
              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.65),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ProductsData data = ProductsData.fromDocuments(
                        snapshot.data!.docs[index],
                      );
                      data.category = this.snapshot.id;

                      //Chama o widger "ProdutsTile" para cada item da coleção, pra construir um CARD
                      // de apresentação, passando por parametro uma string e o item, a strig determinda
                      //se é para exibir em forma de GRID ou LIST.
                      return ProductsTile(
                        type: "grid",
                        data: data,
                      );
                    },
                  ),
                  //======= INICIO DA CONSRUÇÃO DA LIST =======================================
                  ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      ProductsData data = ProductsData.fromDocuments(
                        snapshot.data!.docs[index],
                      );
                      data.category = this.snapshot.id;
                      //Chama o widger "ProdutsTile" para cada item da coleção, pra construir um CARD
                      // de apresentação, passando por parametro uma string e o item, a strig determinda
                      //se é para exibir em forma de GRID ou LIST.
                      return ProductsTile(
                        type: "list",
                        data: data,
                      );
                    }),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
