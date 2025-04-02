import 'package:equatable/equatable.dart';
import '../../../data/data.dart';

abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

class SaveExpense extends ExpenseFormEvent {
  final TravelExpenseModel expense;
  
  const SaveExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class LoadExpense extends ExpenseFormEvent {
  final int expenseId;
  
  const LoadExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class InitializeNewExpense extends ExpenseFormEvent {
  const InitializeNewExpense();
}
