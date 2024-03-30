import 'package:flutter/material.dart';
import 'package:virtal_store/datas/products_data.dart';

import '../screens/product_screen.dart';

//ProductsTile é responsavel por criar os CARD's da grid ou os Itens da LIST, exibida
//na "CategoryScreen". Ela recebe por parametro uma String e o item, ja convertido para
//classe "ProductsTile".

class ProductsTile extends StatelessWidget {
  const ProductsTile({Key? key, required this.type, required this.data})
      : super(key: key);

  final String type;
  final ProductsData data;

  @override
  Widget build(BuildContext context) {
    //InkWell é resposavel pelo geto de clicar no item e redirecionar para a tela
    //de compra e passa por parametro o item.
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              data: data,
            ),
          ),
        );
      },
      //A GRID contem a imgems do item, a titulo e o valor.
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      data.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            data.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "R\$ ${data.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                //A List contem a imgems do item, a titulo e o valor.
                children: [
                  Flexible(
                    child: Image.network(
                      data.images[0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "R\$ ${data.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
