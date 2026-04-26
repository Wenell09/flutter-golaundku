import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await authRepository.login(event.name, event.password);
        emit(AuthSuccess(userId: userId));
      } catch (e) {
        emit(AuthError(message: e.toString().substring(11)));
      }
    });
    on<LogoutUser>((event, emit) async {
      emit(AuthLoading());
      try {
        emit(AuthLogoutSuccess());
      } catch (e) {
        emit(AuthError(message: e.toString().substring(11)));
      }
    });
  }
}
