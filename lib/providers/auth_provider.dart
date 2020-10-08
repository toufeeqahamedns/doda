import 'package:DODA/providers/user_provider.dart';

class AuthProvider {
  Stream<UserProvider> get user {
    return Stream.value(UserProvider.empty);
  }

  Future<bool> logout() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return false;
    } on Exception {
      throw "Logout Exception";
    }
  }
}
