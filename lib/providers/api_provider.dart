import 'dart:io';

import 'package:DODA/models/drawings.dart';
import 'package:DODA/models/markers.dart';
import 'package:DODA/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class ApiProvider {
  final FirebaseFirestore firestoreDB;

  ApiProvider() : firestoreDB = FirebaseFirestore.instance;

  void saveUserToDB(User user) async {
    DocumentReference ref = firestoreDB.collection("/users").doc(user.id);
    final bool userExists = await ref.snapshots().isEmpty;
    print('We have the user saved to DB or not: $userExists');

    if (!userExists) {
      ref.set(user.toDocument(), SetOptions(merge: true));
    }
  }

  Stream<QuerySnapshot> getMarkers(String id) {
    CollectionReference drawings = firestoreDB.collection("/markers");

    return drawings.where("belongsTo", isEqualTo: id).snapshots();
  }

  Stream<QuerySnapshot> getMarkersForUser(User user) {
    CollectionReference drawings = firestoreDB.collection("/markers");

    return drawings.where("owner", isEqualTo: user.id).snapshots();
  }

  Future<void> addDrawing(
      String name, String details, PickedFile file, User user) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(new File(file.path));
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then(
        (value) async => await firestoreDB.runTransaction((transaction) async {
              transaction.set(
                firestoreDB
                    .collection("/drawings")
                    .doc(DateTime.now().millisecondsSinceEpoch.toString()),
                Drawings(
                        belongsTo: user.id,
                        details: details,
                        markers: [],
                        name: name,
                        drawing: value)
                    .toDocument(),
              );
            }));
  }

  Future<void> addMarker(String name, String details, TapPosition position,
      String id, User user) async {
    String documentId = DateTime.now().millisecondsSinceEpoch.toString();

    await firestoreDB.runTransaction((transaction) async {
      transaction.set(
        firestoreDB.collection("/markers").doc(documentId),
        Markers(
                belongsTo: id,
                owner: user.id,
                position: {
                  "dx": position.relative.dx,
                  "dy": position.relative.dy
                },
                name: name,
                details: details)
            .toDocument(),
      );
    });

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("/drawings").doc(id);

    await firestoreDB.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      List<dynamic> markers = snapshot.data()["markers"];
      markers.add(documentId);

      transaction.update(
          firestoreDB.collection("/drawings").doc(id), {"markers": markers});
    });
  }

  Stream<QuerySnapshot> getDrawings(User user) {
    CollectionReference drawings = firestoreDB.collection("/drawings");

    return drawings.where("belongsTo", isEqualTo: user.id).snapshots();
  }
}
