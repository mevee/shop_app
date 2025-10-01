import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/domain/use_cases/login_usecase.dart';
import 'package:shop_app/logic/block/auth/auth_state.dart';
import 'package:shop_app/logic/block/auth/login_event.dart';
import 'package:shop_app/models/login_response.dart';

class LoginBloc extends Bloc<LoginEvent, AuthState> {
  final LoginUsecase loginUsecase;

  LoginBloc(this.loginUsecase) : super(AuthState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginUsecase.call(
      LoginRequest(userName: event.email, password: event.password),
    );
    result.match(
      (failure) => emit(Error(failure)),
      (sucess) => emit(LoginSuccess(sucess.response)),
    );
  }
}
