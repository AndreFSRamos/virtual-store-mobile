import "package:flutter/material.dart";

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({Key? key}) : super(key: key);
  // Widget para retorno um CircularProgressindicator centralizado do do widget que chamou.
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
