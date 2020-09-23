import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {
  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent{
  final String email;
  final String password;
  final String username;

  RegisterEvent({this.email, this.password, this.username});

  @override
  String toString() => 'RegisterEvent';
}

class LoginEvent extends AuthEvent{
  final String email;
  final String password;

  LoginEvent({this.email, this.password});

  @override
  String toString() => 'LoginEvent';
}

class LogoutEvent extends AuthEvent{
  @override
  String toString() => 'LogoutEvent';
}

class ReadUserDataEvent extends AuthEvent{
  @override
  String toString() => 'ReadUserDataEvent';
}


