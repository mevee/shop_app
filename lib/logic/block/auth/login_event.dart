import 'package:equatable/equatable.dart';

/// Base class for all login events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when user presses the login button
class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Triggered when user wants to logout
class LogoutButtonPressed extends LoginEvent {
  const LogoutButtonPressed();
}

/// Triggered when login form fields change (optional)
class LoginTextChanged extends LoginEvent {
  final String email;
  final String password;

  const LoginTextChanged(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}
