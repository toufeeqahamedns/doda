import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  const User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.photo,
  })  : assert(email != null),
        assert(id != null);

  final String id;
  final String email;
  final String name;
  final String photo;

  static const empty = User(id: '', email: '', name: null, photo: null);

  static User fromSnapshot(DocumentSnapshot snap) {
    return User(
      id: snap.id,
      email: snap.data()["email"],
      name: snap.data()["name"],
      photo: snap.data()["photo"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "photo": photo,
    };
  }

  @override
  List<Object> get props => [email, id, name, photo];
}
