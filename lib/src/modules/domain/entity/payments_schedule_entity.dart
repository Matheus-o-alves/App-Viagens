import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

abstract class TravelExpenseEntity extends Equatable {
  final int id;
  final DateTime expenseDate;
  final String description;
  final String categoria;
  final double quantidade;
  final bool reembolsavel;
  final bool isReimbursed;
  final String status;
  final String paymentMethod;

  const TravelExpenseEntity({
    required this.id,
    required this.expenseDate,
    required this.description,
    required this.categoria,
    required this.quantidade,
    required this.reembolsavel,
    required this.isReimbursed,
    required this.status,
    required this.paymentMethod,
  });

  String get expenseDateFormatted => DateFormat('dd/MM/yyyy').format(expenseDate);
  
  double get amount => quantidade;
  
  String get category => categoria;
  
  bool get reimbursable => reembolsavel;

  @override
  List<Object?> get props => [
    id,
    expenseDate,
    description,
    categoria,
    quantidade,
    reembolsavel,
    isReimbursed,
    status,
    paymentMethod,
  ];
}
