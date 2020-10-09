import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Drawings {
  const Drawings({
    @required this.belongsTo,
    @required this.name,
    @required this.details,
    @required this.drawing,
    @required this.markers,
  })  : assert(belongsTo != null),
        assert(drawing != null),
        assert(name != null);

  final String belongsTo;
  final String name;
  final String details;
  final String drawing;
  final List<dynamic> markers;

  static Drawings fromSnapshot(QueryDocumentSnapshot snap) {
    return Drawings(
      belongsTo: snap.data()["belongsTo"],
      name: snap.data()["name"],
      details: snap.data()["details"],
      drawing: snap.data()["drawing"],
      markers: snap.data()["markers"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "belongsTo": belongsTo,
      "name": name,
      "details": details,
      "drawing": drawing,
      "markers": markers,
    };
  }
}
