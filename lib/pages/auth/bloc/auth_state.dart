import 'package:medisains/pages/auth/models/user_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {}

class InitialAuthState extends AuthState {
  @override
  String toString() => 'InitialAuthState';
}

class AuthErrorState extends AuthState {
  final String msg;

  AuthErrorState(this.msg);

  @override
  String toString() => 'AuthErrorState';
}

class RegisterState extends AuthState {
  @override
  String toString() => 'RegisterState';
}

class LoginState extends AuthState {
  final String email;
  final String password;

  LoginState({this.email, this.password});

  @override
  String toString() => 'LoginState';
}

class LogoutState extends AuthState {
  @override
  String toString() => 'LogoutState';
}

class ReadUserDataState extends AuthState {
  final UserModel userModel;

  ReadUserDataState({this.userModel});

  @override
  String toString() => 'ReadUserDataState';
}

class LoginGoogleState extends AuthState {
  @override
  String toString() => 'LoginGoogleState';
}

class RegisterGoogleState extends AuthState {
  @override
  String toString() => 'RegisterGoogleState';
}

class ResetPassState extends AuthState {
  @override
  String toString() => 'ResetPassState';
}

class UpdateProfileState extends AuthState {
  @override
  String toString() => 'UpdateProfileState';
}
