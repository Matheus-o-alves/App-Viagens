// data/models/travel_expense_model.dart
import '../../../../core/core.dart';
import '../../../domain/domain.dart';

class TravelExpenseModel extends TravelExpenseEntity {
  const TravelExpenseModel({
    required super.id,
    required super.expenseDate,
    required super.expenseDateFormatted,
    required super.description,
    required super.category,
    required super.amount,
    required super.reimbursable,
    required super.isReimbursed,
    required super.status,
    required super.paymentMethod,
  });

  factory TravelExpenseModel.fromJson(Map<String, dynamic> map) {
    return TravelExpenseModel(
      id: map['id'] ?? 0,
      expenseDate: DateTime.parse(map['expenseDate'] ?? ""),
      expenseDateFormatted: ConverterHelper.stringNullableToMMDDYYYY(map['expenseDate']),
      description: map['description'] ?? "",
      category: map['category'] ?? "",
      amount: ConverterHelper.dynamicToDouble(map['amount'] ?? 0.0),
      reimbursable: map['reimbursable'] ?? false,
      isReimbursed: map['isReimbursed'] ?? false,
      status: map['status'] ?? "",
      paymentMethod: map['paymentMethod'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseDate': expenseDate.toIso8601String(),
      'description': description,
      'category': category,
      'amount': amount,
      'reimbursable': reimbursable,
      'isReimbursed': isReimbursed,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }
}
