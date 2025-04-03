import 'package:equatable/equatable.dart';

import '../../../../exports.dart';

/// Estados possíveis para o login.
import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';
import '../../../../exports.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoginFormState extends LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isFormValid;

  const LoginFormState({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
    required this.isFormValid,
  });

  @override
  List<Object?> get props => [email, password, emailError, passwordError, isFormValid];
}

class LoginValidationError extends LoginState {
  final String? emailError;
  final String? passwordError;

  const LoginValidationError({
    this.emailError,
    this.passwordError,
  });

  @override
  List<Object?> get props => [emailError, passwordError];
}