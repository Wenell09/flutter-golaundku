part of 'user_bloc.dart';

class UserEvent {}

class GetUser extends UserEvent {
  final String userId;
  GetUser({required this.userId});
}
