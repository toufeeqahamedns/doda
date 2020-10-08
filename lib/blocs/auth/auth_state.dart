import 'package:DODA/providers/user_provider.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = UserProvider.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserProvider user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final UserProvider user;

  @override
  List<Object> get props => [status, user];
}
