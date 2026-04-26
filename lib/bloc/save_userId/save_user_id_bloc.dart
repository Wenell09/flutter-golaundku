import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'save_user_id_event.dart';
part 'save_user_id_state.dart';

class SaveUserIdBloc extends Bloc<SaveUserIdEvent, SaveUserIdState> {
  SaveUserIdBloc() : super(SaveUserIdInitial()) {
    on<LoadUserId>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId") ?? "";
      if (userId.isEmpty) {
        debugPrint("id empty:$userId");
        emit(SaveUserEmpty());
      } else {
        debugPrint("id load:$userId");
        emit(SaveUserLoaded(userId: userId));
      }
    });

    on<SaveUserId>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", event.userId);
      debugPrint("id dibuat:${event.userId}");
      if (event.userId.isEmpty) {
        emit(SaveUserEmpty());
      } else {
        emit(SaveUserLoaded(userId: event.userId));
      }
    });
  }
}
