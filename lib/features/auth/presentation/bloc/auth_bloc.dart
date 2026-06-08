import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentMemberUseCase _getCurrentMemberUseCase;

  AuthBloc(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._getCurrentMemberUseCase,
      ) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _getCurrentMemberUseCase();
    result.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (member) {
        if (member != null) {
          emit(AuthAuthenticated(member));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(LoginParams(
      mobileNumber: event.mobileNumber,
      password: event.password,
    ));
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (member) => emit(AuthAuthenticated(member)),
    );
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(RegisterParams(
      fullName: event.fullName,
      mobileNumber: event.mobileNumber,
      password: event.password,
      district: event.district,
      thana: event.thana,
      address: event.address,
    ));
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(const AuthRegistered()),
    );
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}