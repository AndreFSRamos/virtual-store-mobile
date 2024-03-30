import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesTile extends StatelessWidget {
  const PlacesTile({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(
              snapshot["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot["title"],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  snapshot["address"],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("Ver no Mapa"),
                onPressed: () {
                  launch(
                      "https://wwww.google.com/maps/@${snapshot["lat"]},${snapshot["long"]},17z");
                },
              ),
              TextButton(
                child: const Text("Ligar"),
                onPressed: () {
                  launch("tel:${snapshot["phone"]}");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
