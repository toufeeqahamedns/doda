import 'package:DODA/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthBloc>().state.user;
    return Scaffold(
        body: Center(child: Text("Discuss On Drawings App ${user.name}")));
  }
}
