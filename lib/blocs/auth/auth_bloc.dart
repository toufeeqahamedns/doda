import 'dart:async';

import 'package:DODA/blocs/auth/auth_event.dart';
import 'package:DODA/blocs/auth/auth_state.dart';
import 'package:DODA/providers/auth_provider.dart';
import 'package:DODA/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    @required AuthProvider authProvider,
  })  : assert(authProvider != null),
        _authProvider = authProvider,
        super(const AuthState.unknown()) {
    _userSubscription = authProvider.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthProvider _authProvider;
  StreamSubscription<User> _userSubscription;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged) {
      yield _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      if(await _authProvider.logout()) {
        yield AuthState.unauthenticated();
      }

    }
  }

   @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthState _mapAuthUserChangedToState(
    AuthUserChanged event,
  ) {
    return event.user != User.empty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated();
  }
}
