import 'package:DODA/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_Auth;
import 'package:google_sign_in/google_sign_in.dart';
class AuthProvider {

  final firebase_Auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

AuthProvider({
    firebase_Auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase_Auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

   Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = firebase_Auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw "Login Exception";
    }
  }

  Future<bool> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return true;
    } on Exception {
      throw "Logout Exception";
    }
  }
}

extension on firebase_Auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
