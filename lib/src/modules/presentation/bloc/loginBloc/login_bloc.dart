import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../exports.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginFormValidated>(_onLoginFormValidated);
  }
  
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  
  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    _email = event.email;
    _password = event.password;
    
    final bool isValid = _validateForm();
    
    if (!isValid) {
      emit(LoginValidationError(
        emailError: _emailError,
        passwordError: _passwordError
      ));
      return;
    }
    
    emit(LoginLoading());
    
    try {
      final UserEntity user = await loginUseCase(_email, _password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
  
  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    _email = event.email;
    _emailError = _validateEmail(_email);
    
    emit(LoginFormState(
      email: _email,
      password: _password,
      emailError: _emailError,
      passwordError: _passwordError,
      isFormValid: _emailError == null && _passwordError == null && _email.isNotEmpty && _password.isNotEmpty
    ));
  }
  
  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    _password = event.password;
    _passwordError = _validatePassword(_password);
    
    emit(LoginFormState(
      email: _email,
      password: _password,
      emailError: _emailError,
      passwordError: _passwordError,
      isFormValid: _emailError == null && _passwordError == null && _email.isNotEmpty && _password.isNotEmpty
    ));
  }
  
  void _onLoginFormValidated(LoginFormValidated event, Emitter<LoginState> emit) {
    final bool isValid = _validateForm();
    
    if (isValid) {
      emit(LoginFormState(
        email: _email,
        password: _password,
        emailError: null,
        passwordError: null,
        isFormValid: true
      ));
    } else {
      emit(LoginValidationError(
        emailError: _emailError,
        passwordError: _passwordError
      ));
    }
  }
  
  bool _validateForm() {
    _emailError = _validateEmail(_email);
    _passwordError = _validatePassword(_password);
    
    return _emailError == null && _passwordError == null;
  }
  
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor, insira seu email';
    }
    
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(email)) {
      return 'Por favor, insira um email válido';
    }
    
    return null;
  }
  

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }
}