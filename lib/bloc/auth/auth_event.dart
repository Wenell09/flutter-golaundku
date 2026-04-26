part of 'auth_bloc.dart';

class AuthEvent {}

class LoginUser extends AuthEvent {
  final String name;
  final String password;
  LoginUser({required this.name, required this.password});
}

class LogoutUser extends AuthEvent {}
