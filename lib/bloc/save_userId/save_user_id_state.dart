part of 'save_user_id_bloc.dart';

sealed class SaveUserIdState {}

final class SaveUserIdInitial extends SaveUserIdState {}

final class SaveUserLoaded extends SaveUserIdState {
  final String userId;
  SaveUserLoaded({required this.userId});
}

final class SaveUserEmpty extends SaveUserIdState {}
