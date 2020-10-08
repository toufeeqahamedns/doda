import 'package:DODA/providers/user_provider.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserProvider user;

  @override
  List<Object> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
