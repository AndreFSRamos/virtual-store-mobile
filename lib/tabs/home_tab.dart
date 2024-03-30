import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';

//HOMETAB é page da posição 0 na DRAWER, ela contem uma grid de imagens com
//proporsões diferente para criar um efeito bonito, essas proporções são defeidas
//no firebase nos campos "X" e "Y" da coleção HOME, a ordem das imagens também
//são definidas do firebase, no campo "pos".

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //====================== CRIANDO O EFEITO GRADIENTE =======================
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 214, 21, 125),
                Color.fromARGB(255, 245, 171, 224)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Stack(
      children: [
        _buildBodyBack(), //APLICANDO O GRADIENTE DO BACKGROUD DA PAGE.
        CustomScrollView(
          slivers: [
            //=================== INICIO DA APP BAR E SEUS EFEITOS ============
            const SliverAppBar(
              floating: true,
              elevation: 0,
              snap: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('UzzuBiju'),
                centerTitle: true,
              ),
            ),
            //Ultilizado o FutureBuilder para recuperar os dadaos do firebase.
            FutureBuilder<QuerySnapshot>(
              //Furute: recupera os dados no firebase da coleção home, ordenado pelo
              //campo "pos".
              future: FirebaseFirestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .get(),
              builder: (context, snapshot) {
                //Verifica se a Snapshot é diferente de fazio, caso SIM, ira apresentar
                // icones animado, idicando que está aguarando uma resposta. Caso contrario
                //apresenta um grid de imagens.
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularIndicator(),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                      //Nessarios usar o "StaggerGrid.count" para que seja possivel, usar
                      //as proporções de X e Y.
                      child: StaggeredGrid.count(
                    crossAxisCount: 2, //determina a quantidade de colunas.
                    crossAxisSpacing: 1, //espaço entre as colunas.
                    mainAxisSpacing: 1, // espaço cima e baixo.
                    //Mapeando todos os objetos do map e para dada objeto é retornado o
                    // os valores do campo "X", "Y" e a URL da imagem.
                    children: snapshot.data!.docs.map(
                      (doc) {
                        return StaggeredGridTile.count(
                            crossAxisCellCount: doc["x"],
                            mainAxisCellCount: doc["y"],
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc["image"],
                              fit: BoxFit.cover,
                            ));
                      },
                    ).toList(),
                  ));
                }
              },
            )
          ],
        )
      ],
    );
  }
}
