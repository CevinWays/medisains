import 'package:meta/meta.dart';

@immutable
abstract class AuthState {
  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {
  @override
  String toString() => 'InitialAuthState';
}

class AuthErrorState extends AuthState{
  final String msg;

  AuthErrorState(this.msg);
  @override
  String toString() => 'AuthErrorState';
}

class RegisterState extends AuthState{
  @override
  String toString() => 'RegisterState';
}

class LoginState extends AuthState{
  final String email;
  final String password;

  LoginState({this.email, this.password});

  @override
  String toString() => 'LoginState';
}

class LogoutState extends AuthState{
  @override
  String toString() => 'LogoutState';
}

class ReadUserDataState extends AuthState{
  final String username;
  final String email;

  ReadUserDataState({this.username, this.email});
  @override
  String toString() => 'ReadUserDataState';
}
