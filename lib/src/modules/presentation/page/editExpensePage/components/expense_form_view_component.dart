import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../exports.dart';
import 'expense_form_component.dart';
import 'saving_indicator_component.dart';

class _ExpenseFormView extends StatefulWidget {
  const _ExpenseFormView();

  @override
  State<_ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<_ExpenseFormView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
          buildWhen: (previous, current) => current is ExpenseFormLoaded,
          builder: (context, state) {
            if (state is ExpenseFormLoaded) {
              return Text(
                state.expense == null ? 'Adicionar Despesa' : 'Editar Despesa',
                style: const TextStyle(color: Colors.white),
              );
            }
            return const Text('Despesa', style: TextStyle(color: Colors.white));
          },
        ),
        backgroundColor: const Color(0xFF1A73E8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<ExpenseFormBloc, ExpenseFormState>(
        listener: (context, state) {
          if (state is ExpenseFormSuccess) {
            _showSuccessMessage(context, state.message);
            _refreshExpensesList(context);
            _navigateBack(context);
          } else if (state is ExpenseFormError) {
            _showErrorMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ExpenseFormLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseFormSaving) {
            return const SavingIndicator();
          } else if (state is ExpenseFormLoaded) {
            return ExpenseForm(state: state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _refreshExpensesList(BuildContext context) {
    context.read<TravelExpensesBloc>().add(const RefreshTravelExpenses());
  }

  void _navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}