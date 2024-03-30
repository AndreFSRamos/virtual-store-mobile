import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';

import '../tiles/places_tile.dart';

class PlacesTab extends StatelessWidget {
  const PlacesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("places").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularIndicator();
          } else {
            return ListView(
                children: snapshot.data!.docs
                    .map((doc) => PlacesTile(snapshot: doc))
                    .toList());
          }
        });
  }
}
