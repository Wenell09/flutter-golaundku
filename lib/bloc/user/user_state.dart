part of 'user_bloc.dart';

class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final UserModel userData;
  UserLoaded({required this.userData});
}

final class UserError extends UserState {}
