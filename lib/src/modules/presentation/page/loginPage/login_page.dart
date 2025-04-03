import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../exports.dart';
import '../../bloc/loginBloc/login_bloc.dart';

import 'component.dart/login_form_component.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tagBlue,
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: const LoginForm(),
      ),
    );
  }
}