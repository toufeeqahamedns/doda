import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Markers {
  const Markers({
    @required this.belongsTo,
    @required this.owner,
    @required this.position,
    @required this.name,
    @required this.details,
  })  : assert(belongsTo != null),
        assert(position != null),
        assert(name != null);

  final String belongsTo;
  final String owner;
  final Map<String, double> position;
  final String name;
  final String details;

  static Markers fromSnapshot(QueryDocumentSnapshot snap) {
    return Markers(
      belongsTo: snap.data()["belongsTo"],
      owner: snap.data()["owner"],
      position: snap.data()["position"],
      name: snap.data()["name"],
      details: snap.data()["details"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "belongsTo": belongsTo,
      "owner": owner,
      "position": position,
      "name": name,
      "details": details,
    };
  }
}
