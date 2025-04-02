// presentation/bloc/expenseFormBloc/expense_form_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entity/entity.dart';

abstract class ExpenseFormState extends Equatable {
  const ExpenseFormState();

  @override
  List<Object?> get props => [];
}

class ExpenseFormInitial extends ExpenseFormState {}

class ExpenseFormLoading extends ExpenseFormState {}

class ExpenseFormReady extends ExpenseFormState {
  final TravelExpenseEntity? expense;
  
  const ExpenseFormReady({this.expense});

  @override
  List<Object?> get props => [expense];
}

class ExpenseFormSaving extends ExpenseFormState {}

class ExpenseFormSuccess extends ExpenseFormState {
  final bool isNewExpense;
  final String message;
  
  const ExpenseFormSuccess({
    required this.isNewExpense,
    required this.message,
  });

  @override
  List<Object?> get props => [isNewExpense, message];
}

class ExpenseFormError extends ExpenseFormState {
  final String message;
  
  const ExpenseFormError(this.message);

  @override
  List<Object?> get props => [message];
}
