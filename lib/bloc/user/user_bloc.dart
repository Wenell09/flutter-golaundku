import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/user_model.dart';
import 'package:flutter_golaundku/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserInitial()) {
    on<GetUser>((event, emit) async {
      emit(UserLoading());
      try {
        final userData = await userRepository.getUser(event.userId);
        emit(UserLoaded(userData: userData));
      } catch (e) {
        emit(UserError());
      }
    });
  }
}
