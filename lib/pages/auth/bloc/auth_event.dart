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

class LoginGoogleEvent extends AuthEvent{
  @override
  String toString() => 'LoginGoogleEvent';
}

class RegisterGoogleEvent extends AuthEvent{
  @override
  String toString() => 'RegisterGoogleEvent';
}

class ResetPassEvent extends AuthEvent{
  final String email;

  ResetPassEvent({this.email});

  @override
  String toString() => 'ResetPassEvent';
}

class UpdateProfileEvent extends AuthEvent{
  final String instansi;
  final String noHp;
  final String gender;
  final String location;
  final String education;

  UpdateProfileEvent({this.instansi, this.noHp, this.gender,this.location, this.education});

  @override
  String toString() => 'UpdateProfileEvent';
}


