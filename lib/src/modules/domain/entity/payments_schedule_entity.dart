// domain/entities/travel_expense_entity.dart
import 'package:equatable/equatable.dart';

abstract class TravelExpenseEntity extends Equatable {
  final int id;
  final DateTime expenseDate;
  final String expenseDateFormatted;
  final String description;
  final String category;
  final double amount;
  final bool reimbursable;
  final bool isReimbursed;
  final String status;
  final String paymentMethod;

  const TravelExpenseEntity({
    required this.id,
    required this.expenseDate,
    required this.expenseDateFormatted,
    required this.description,
    required this.category,
    required this.amount,
    required this.reimbursable,
    required this.isReimbursed,
    required this.status,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    id,
    expenseDate,
    expenseDateFormatted,
    description,
    category,
    amount,
    reimbursable,
    isReimbursed,
    status,
    paymentMethod,
  ];
}
