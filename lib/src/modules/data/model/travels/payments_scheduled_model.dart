// data/models/travel_expense_model.dart
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/helper_formatter.dart';
import '../../../domain/domain.dart';

class TravelExpenseModel extends TravelExpenseEntity {
  const TravelExpenseModel({
    required super.id,
    required super.expenseDate,
    required super.description,
    required super.categoria,
    required super.quantidade,
    required super.reembolsavel,
    required super.isReimbursed,
    required super.status,
    required super.paymentMethod,
  });

factory TravelExpenseModel.fromJson(Map<String, dynamic> json) {
  return TravelExpenseModel(
    id: json['id'] ?? 0,
    expenseDate: json['expenseDate'] is String 
      ? DateTime.parse(json['expenseDate']) 
      : json['expenseDate'],
    description: json['description'] ?? '',
    categoria: json['category'] ?? json['categoria'] ?? '',
    quantidade: (json['amount'] ?? json['quantidade'] ?? 0.0).toDouble(),
    reembolsavel: _convertToBool(json['reimbursable'] ?? json['reembolsavel'] ?? false),
    isReimbursed: _convertToBool(json['isReimbursed'] ?? false),
    status: json['status'] ?? '',
    paymentMethod: json['paymentMethod'] ?? '',
  );
}

// Método auxiliar para conversão segura para booleano
static bool _convertToBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'expenseDate': expenseDate.toIso8601String(),
    'description': description,
    'category': categoria,
    'amount': quantidade,
    'reimbursable': reembolsavel ? 1 : 0,
    'isReimbursed': isReimbursed ? 1 : 0,
    'status': status,
    'paymentMethod': paymentMethod,
  };
}

Map<String, dynamic> toDatabaseMap() {
  return {
    'id': id,
    'expenseDate': expenseDate.toIso8601String(),
    'description': description,
    'categoria': categoria,
    'quantidade': quantidade,
    'reembolsavel': reembolsavel ? 1 : 0,
    'isReimbursed': isReimbursed ? 1 : 0,
    'status': status,
    'paymentMethod': paymentMethod,
  };
}
}