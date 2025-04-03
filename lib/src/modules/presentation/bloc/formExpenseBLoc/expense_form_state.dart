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

class ExpenseFormLoaded extends ExpenseFormState {
  final TravelExpenseEntity? expense;
  final DateTime date;
  final String description;
  final String category;
  final double amount;
  final String paymentMethod;
  final bool isReimbursable;
  final List<String> categories;
  final List<String> paymentMethods;
  final String? descriptionError;
  final String? amountError;
  
  const ExpenseFormLoaded({
    required this.expense,
    required this.date,
    required this.description,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.isReimbursable,
    required this.categories,
    required this.paymentMethods,
    this.descriptionError,
    this.amountError,
  });
  
  bool get isValid => descriptionError == null && amountError == null;

  @override
  List<Object?> get props => [
    expense, 
    date, 
    description, 
    category, 
    amount, 
    paymentMethod, 
    isReimbursable,
    categories,
    paymentMethods,
    descriptionError,
    amountError,
  ];
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