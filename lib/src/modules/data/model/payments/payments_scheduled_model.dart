// data/models/travel_expense_model.dart
import '../../../../core/core.dart';
import '../../../../core/utils/helper_formatter.dart';
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
      // Normalizar a categoria
      category: TextNormalizer.ensureValidCategory(map['category'] ?? ""),
      amount: ConverterHelper.dynamicToDouble(map['amount'] ?? 0.0),
      reimbursable: map['reimbursable'] ?? false,
      isReimbursed: map['isReimbursed'] ?? false,
      status: map['status'] ?? "",
      // Normalizar o método de pagamento
      paymentMethod: TextNormalizer.ensureValidPaymentMethod(map['paymentMethod'] ?? ""),
    );
  }

  factory TravelExpenseModel.fromDbMap(Map<String, dynamic> map) {
    final dateStr = map['expenseDate'] as String;
    return TravelExpenseModel(
      id: map['id'] as int,
      expenseDate: DateTime.parse(dateStr),
      expenseDateFormatted: ConverterHelper.stringNullableToMMDDYYYY(dateStr),
      description: map['description'] as String,
      // Normalizar a categoria
      category: TextNormalizer.ensureValidCategory(map['category'] as String),
      amount: map['amount'] as double,
      reimbursable: map['reimbursable'] == 1,
      isReimbursed: map['isReimbursed'] == 1,
      status: map['status'] as String,
      // Normalizar o método de pagamento
      paymentMethod: TextNormalizer.ensureValidPaymentMethod(map['paymentMethod'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseDate': expenseDate.toIso8601String(),
      'description': description,
      'category': category,  // Já normalizado
      'amount': amount,
      'reimbursable': reimbursable,
      'isReimbursed': isReimbursed,
      'status': status,
      'paymentMethod': paymentMethod,  // Já normalizado
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id == 0 ? null : id,
      'expenseDate': expenseDate.toIso8601String(),
      'description': description,
      'category': category,  // Já normalizado
      'amount': amount,
      'reimbursable': reimbursable ? 1 : 0,
      'isReimbursed': isReimbursed ? 1 : 0,
      'status': status,
      'paymentMethod': paymentMethod,  // Já normalizado
    };
  }

  TravelExpenseModel copyWith({
    int? id,
    DateTime? expenseDate,
    String? expenseDateFormatted,
    String? description,
    String? category,
    double? amount,
    bool? reimbursable,
    bool? isReimbursed,
    String? status,
    String? paymentMethod,
  }) {
    return TravelExpenseModel(
      id: id ?? this.id,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseDateFormatted: expenseDateFormatted ?? this.expenseDateFormatted,
      description: description ?? this.description,
      // Normalizar a categoria se fornecida
      category: category != null ? TextNormalizer.ensureValidCategory(category) : this.category,
      amount: amount ?? this.amount,
      reimbursable: reimbursable ?? this.reimbursable,
      isReimbursed: isReimbursed ?? this.isReimbursed,
      status: status ?? this.status,
      // Normalizar o método de pagamento se fornecido
      paymentMethod: paymentMethod != null 
          ? TextNormalizer.ensureValidPaymentMethod(paymentMethod) 
          : this.paymentMethod,
    );
  }
}