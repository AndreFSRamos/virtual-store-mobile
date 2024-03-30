import 'package:flutter/material.dart';

class TextFieldAux extends StatelessWidget {
  const TextFieldAux(
      {Key? key,
      required this.label,
      required this.enable,
      required this.controller,
      required this.hint,
      required this.keyType})
      : super(key: key);

  final String label;
  final String hint;
  final bool enable;
  final TextEditingController controller;
  final TextInputType keyType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        enabled: enable,
        hintText: hint,
      ),
    );
  }
}
