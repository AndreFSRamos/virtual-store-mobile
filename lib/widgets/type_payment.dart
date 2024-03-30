import 'package:flutter/material.dart';
import '../datas/products_data.dart';

class TypePayment extends StatefulWidget {
  TypePayment({Key? key, required this.data}) : super(key: key);
  final ProductsData data;

  @override
  State<TypePayment> createState() => _TypePaymentState();
}

class _TypePaymentState extends State<TypePayment> {
  String typePayment = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Forma de Pagamento",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 36,
            child: GridView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 8, childAspectRatio: 0.5),
              /* children: widget.data.typePayment.map((optionTypePayment) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      typePayment = optionTypePayment;
                    });
                    CartModel.of(context).typePay(typePayment);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                      border: Border.all(
                          color: optionTypePayment == typePayment
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: 3),
                    ),
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      optionTypePayment,
                    ),
                  ),
                );
              }).toList(),*/
            ),
          ),
        ],
      ),
    );
  }
}
