import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../bloc/loginBloc/login_bloc.dart';
import '../../../bloc/loginBloc/login_event.dart';
import '../../../bloc/loginBloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController(text: 'teste@onfly.com');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().add(EmailChanged(_emailController.text));
  }

  void _onPasswordChanged() {
    context.read<LoginBloc>().add(PasswordChanged(_passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        return current is LoginSuccess || 
               current is LoginFailure || 
               current is LoginValidationError;
      },
      listener: (context, state) {
        if (state is LoginSuccess) {
          _showSnackbar(context, 'Login realizado com sucesso!');
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is LoginFailure) {
          _showSnackbar(context, state.error);
        }
      },
      buildWhen: (previous, current) {
        return current is LoginInitial || 
               current is LoginLoading || 
               current is LoginFormState || 
               current is LoginValidationError;
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 32),
                  _buildEmailField(context, state),
                  const SizedBox(height: 16),
                  _buildPasswordField(context, state),
                  const SizedBox(height: 32),
                  _buildLoginButton(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return const Text(
      "OnFly",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, LoginState state) {
    String? emailError;
    if (state is LoginFormState) {
      emailError = state.emailError;
    } else if (state is LoginValidationError) {
      emailError = state.emailError;
    }

    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: AppColors.white),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email, color: AppColors.white),
        errorText: emailError,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.white),
        ),
      ),
      style: const TextStyle(color: AppColors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginState state) {
    String? passwordError;
    if (state is LoginFormState) {
      passwordError = state.passwordError;
    } else if (state is LoginValidationError) {
      passwordError = state.passwordError;
    }

    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Senha',
        labelStyle: const TextStyle(color: AppColors.white),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock, color: AppColors.white),
        errorText: passwordError,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.white),
        ),
      ),
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<LoginBloc>().add(
                LoginSubmitted(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          "Entrar",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.tagBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
