import 'package:DODA/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(tag: "logo", child: Image.asset("assets/app_icon.png")),
                SizedBox(height: 5.0),
                Text(
                  "Discuss On Drawings",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Consumer(
                  builder: (BuildContext context, AuthProvider authProvider,
                      Widget child) {
                    return MaterialButton(
                      height: 40.0,
                      onPressed: () => authProvider.signInWithGoogle(),
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            "assets/google_logo.png",
                            height: 18.0,
                            width: 18.0,
                          ),
                          SizedBox(
                            width: 24.0,
                          ),
                          Opacity(
                            opacity: 0.54,
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  fontFamily: 'Roboto-Medium',
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
