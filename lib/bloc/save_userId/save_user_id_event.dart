part of 'save_user_id_bloc.dart';

sealed class SaveUserIdEvent {}

class SaveUserId extends SaveUserIdEvent {
  final String userId;
  SaveUserId({required this.userId});
}

class LoadUserId extends SaveUserIdEvent {}
