import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:DODA/blocs/auth/auth_state.dart';
import 'package:DODA/providers/api_provider.dart';
import 'package:DODA/providers/auth_provider.dart';
import 'package:DODA/models/user.dart';
import 'package:DODA/views/home_screen.dart';
import 'package:DODA/views/login_screen.dart';
import 'package:DODA/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (_) => AuthProvider(),
      ),
      Provider(create: (_) => ApiProvider())
    ],
    child: Consumer(
      builder: (BuildContext context, AuthProvider authProvider, Widget child) {
        return BlocProvider(
          create: (_) => AuthBloc(authProvider: authProvider),
          child: DODA(),
        );
      },
    ),
  ));
}

class DODA extends StatelessWidget {
  final GlobalKey _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        builder: (BuildContext context, Widget child) {
          return BlocListener<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState state) {
                switch (state.status) {
                  case AuthStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        MaterialPageRoute<void>(builder: (_) => HomeScreen()),
                        (route) => false);
                    break;
                  case AuthStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil(
                        MaterialPageRoute<void>(builder: (_) => LoginScreen()),
                        (route) => false);
                    break;
                  default:
                    break;
                }
              },
              child: child);
        },
        title: 'Doda',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (_) =>
            MaterialPageRoute<void>(builder: (_) => SplashScreen()));
  }
}
