import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatelessWidget {
  final Future<FirebaseApp> firebaseInitialize = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseInitialize,
        builder: (BuildContext context, AsyncSnapshot snapahot) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "logo",
                    child: Image.asset("assets/app_icon.png")),
                  SizedBox(height: 5.0),
                  Text(
                    "Discuss On Drawings",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
