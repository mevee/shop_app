import 'package:equatable/equatable.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

// ignore: must_be_immutable
class AuthState extends Equatable {
  var passVisible=false;
  var remember=false;
  AuthState({this.passVisible=false});
  @override
  List<Object?> get props => [passVisible];
}

class LoginLoading extends AuthState {}

class OtpLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final LoginResponse response;
  LoginSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class Error extends AuthState {
  final Failure failure;
  Error(this.failure);
  @override
  List<Object?> get props => [failure];
}

class OtpSuccess extends AuthState {
  final String message;
  OtpSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
