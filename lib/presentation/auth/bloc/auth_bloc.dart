import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<RegisterEvent>(_register);
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }

  Future<void> _register(
      RegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await authService.register(
        event.email,
        event.password,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _login(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await authService.login(
        event.email,
        event.password,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _logout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await authService.logout();

      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}