import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../exports.dart';


class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String expenseForm = '/expense-form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => GetIt.I<TravelExpensesBloc>(),
                child: const TravelExpensesPage(),
              ),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case expenseForm:
        final expense = settings.arguments as TravelExpenseEntity?;
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: GetIt.I<TravelExpensesBloc>()),
                  BlocProvider(create: (_) => GetIt.I<ExpenseFormBloc>()),
                ],
                child: ExpenseFormPage(expense: expense),
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Rota não definida para ${settings.name}'),
                ),
              ),
        );
    }
  }
}
