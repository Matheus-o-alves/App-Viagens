import 'package:equatable/equatable.dart';
import '../../../data/data.dart';
abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNewExpense extends ExpenseFormEvent {
  const InitializeNewExpense();
}

class LoadExpense extends ExpenseFormEvent {
  final int expenseId;
  
  const LoadExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class SaveExpense extends ExpenseFormEvent {
  final TravelExpenseModel expense;
  
  const SaveExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DateChanged extends ExpenseFormEvent {
  final DateTime date;
  
  const DateChanged(this.date);
  
  @override
  List<Object?> get props => [date];
}

class DescriptionChanged extends ExpenseFormEvent {
  final String description;
  
  const DescriptionChanged(this.description);
  
  @override
  List<Object?> get props => [description];
}

class CategoryChanged extends ExpenseFormEvent {
  final String category;
  
  const CategoryChanged(this.category);
  
  @override
  List<Object?> get props => [category];
}

class AmountChanged extends ExpenseFormEvent {
  final String amount;
  
  const AmountChanged(this.amount);
  
  @override
  List<Object?> get props => [amount];
}

class PaymentMethodChanged extends ExpenseFormEvent {
  final String paymentMethod;
  
  const PaymentMethodChanged(this.paymentMethod);
  
  @override
  List<Object?> get props => [paymentMethod];
}

class ReimbursableChanged extends ExpenseFormEvent {
  final bool isReimbursable;
  
  const ReimbursableChanged(this.isReimbursable);
  
  @override
  List<Object?> get props => [isReimbursable];
}

class ValidateForm extends ExpenseFormEvent {
  const ValidateForm();
}
