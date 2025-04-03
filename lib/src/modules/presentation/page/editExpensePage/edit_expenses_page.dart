import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';
import 'components/expense_form_component.dart';
import 'components/saving_indicator_component.dart';


class ExpenseFormPage extends StatelessWidget {
  final TravelExpenseEntity? expense;

  const ExpenseFormPage({super.key, this.expense});

  @override
  Widget build(BuildContext context) {
    if (expense != null) {
      context.read<ExpenseFormBloc>().add(LoadExpense(expense!.id));
    } else {
      context.read<ExpenseFormBloc>().add(const InitializeNewExpense());
    }

    return const ExpenseFormView();
  }
}

class ExpenseFormView extends StatelessWidget {
  const ExpenseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
          buildWhen: (previous, current) => 
              current is ExpenseFormLoaded || current is ExpenseFormReady,
          builder: (context, state) {
            final bool isNewExpense = state is ExpenseFormReady 
                ? state.expense == null 
                : (state is ExpenseFormLoaded ? state.expense == null : true);
                
            return Text(
              isNewExpense ? 'Adicionar Despesa' : 'Editar Despesa',
              style: const TextStyle(color: Colors.white),
            );
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
          } else if (state is ExpenseFormReady) {
            return const Center(
              child: Text('O formulário está sendo preparado...'),
            );
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
