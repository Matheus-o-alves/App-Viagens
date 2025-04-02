// data/models/travel_expense_model.dart
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/helper_formatter.dart';
import '../../../domain/domain.dart';

class TravelExpenseModel extends TravelExpenseEntity {
  TravelExpenseModel({
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
    final DateTime date = json['expenseDate'] != null 
        ? DateTime.parse(json['expenseDate']) 
        : DateTime.now();

    return TravelExpenseModel(
      id: json['id'] ?? json['identidade'] ?? 0,
      expenseDate: date,
      description: json['description'] ?? json['descrição'] ?? '',
      categoria: json['categoria'] ?? '',
      quantidade: (json['quantidade'] ?? 0.0).toDouble(),
      reembolsavel: (json['reembolsável'] ?? 0) == 1,
      isReimbursed: (json['isReimbursed'] ?? 0) == 1,
      status: json['status'] ?? 'programado',
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }

  // Para compatibilidade com código legado (naming diferente)
  factory TravelExpenseModel.fromLegacyJson(Map<String, dynamic> json) {
    final DateTime date = json['expenseDate'] != null 
        ? DateTime.parse(json['expenseDate']) 
        : DateTime.now();

    return TravelExpenseModel(
      id: json['id'] ?? 0,
      expenseDate: date,
      description: json['description'] ?? '',
      categoria: json['category'] ?? '',
      quantidade: (json['amount'] ?? 0.0).toDouble(),
      reembolsavel: (json['reimbursable'] ?? 0) == 1,
      isReimbursed: (json['isReimbursed'] ?? 0) == 1,
      status: json['status'] ?? 'programado',
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }

  /// Usado para comunicação com a API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseDate': expenseDate.toIso8601String(),
      'descrição': description,
      'categoria': categoria,
      'quantidade': quantidade,
      'reembolsável': reembolsavel,
      'isReimbursed': isReimbursed,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  /// Usado para salvar localmente no SQLite (sqflite)
Map<String, dynamic> toDatabaseMap() {
  return {
    'id': id,
    'expenseDate': expenseDate.toIso8601String(),
    'description': description,       // ✅ sem acento
    'categoria': categoria,
    'quantidade': quantidade,
    'reembolsavel': reembolsavel ? 1 : 0, // ✅ sem acento
    'isReimbursed': isReimbursed ? 1 : 0,
    'status': status,
    'paymentMethod': paymentMethod,
  };
}

  /// Compatível com dados legados
  Map<String, dynamic> toLegacyJson() {
    return {
      'id': id,
      'expenseDate': expenseDate.toIso8601String(),
      'expenseDateFormatted': DateFormat('MM/dd/yyyy').format(expenseDate),
      'description': description,
      'category': categoria,
      'amount': quantidade,
      'reimbursable': reembolsavel,
      'isReimbursed': isReimbursed,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  TravelExpenseModel copyWith({
    int? id,
    DateTime? expenseDate,
    String? description,
    String? categoria,
    double? quantidade,
    bool? reembolsavel,
    bool? isReimbursed,
    String? status,
    String? paymentMethod,
  }) {
    return TravelExpenseModel(
      id: id ?? this.id,
      expenseDate: expenseDate ?? this.expenseDate,
      description: description ?? this.description,
      categoria: categoria ?? this.categoria,
      quantidade: quantidade ?? this.quantidade,
      reembolsavel: reembolsavel ?? this.reembolsavel,
      isReimbursed: isReimbursed ?? this.isReimbursed,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
