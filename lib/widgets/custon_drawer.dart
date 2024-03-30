import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtal_store/models/user_model.dart';
import 'package:virtal_store/screens/login_screen.dart';
import 'package:virtal_store/tiles/drawer_tile.dart';

// Widget "CustonDrawer" é responsavel pela contrução da tela de munu (DRAWER),
// ela contem cada opção do munu, porem as cunfuionalidades são responsabulidade
// da widget "DrawerTile". Essa widget recebe da widget "HomeScreen" por parametro
// a controler "pageContreller", para auxilar no escolha das pages.

class CustonDrawer extends StatelessWidget {
  const CustonDrawer({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

//================= INICIO DO CORPO DA DRAWER =================================
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 248, 182, 218), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
    return Drawer(
      child: Stack(
        children: [
          _buildBodyBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32, top: 30),
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 8,
                      left: 8,
                      child: Text(
                        'UZZUBIJU',
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          print("usuario Logado: ${model.isLoadingIn()}");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                !model.isLoadingIn()
                                    ? "Seja Bem Vindo!"
                                    : "Olá, ${model.userdata["name"]}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoadingIn()
                                      ? "Entre ou cadastre-se >"
                                      : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (!model.isLoadingIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  } else {
                                    model.singOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //Opção do menu, INICIO, PRODUTOS, LOJAS e MEUS PEDIDOS. Cada opção
              //chama o widget "DrawerTile" para que seja craiada os efeitos de
              //click e mudançãs de cores.e passa por parametro, um icone, text,
              // a controller, a numero da pagina (Numero da paigina tem que iniciar
              // 0), atraz
              const Divider(),
              DrawerTile(
                icon: Icons.home,
                text: "Inicio",
                pageController: pageController,
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                text: "Produtos",
                pageController: pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: "Lojas",
                pageController: pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: "Meus pedidos",
                pageController: pageController,
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
