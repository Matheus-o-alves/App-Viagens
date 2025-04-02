
import '../../../../exports.dart';
import 'travel_card_model.dart';

class TravelExpensesInfoModel extends TravelExpensesInfoEntity {
  const TravelExpensesInfoModel({
    required List<TravelExpenseModel> despesasdeviagem,
    required List<TravelCardModel> cartoes,
  }) : super(
    despesasdeviagem: despesasdeviagem,
    cartoes: cartoes,
  );

  factory TravelExpensesInfoModel.fromJson(Map<String, dynamic> json) {
    final List<TravelExpenseModel> expenses = (json['despesasdeviagem'] as List?)
      ?.map((expenseJson) => TravelExpenseModel.fromJson(expenseJson))
      .toList() ?? [];
    
    final List<TravelCardModel> cards = (json['cartoes'] as List?)
      ?.map((cardJson) => TravelCardModel.fromJson(cardJson))
      .toList() ?? [];
    
    return TravelExpensesInfoModel(
      despesasdeviagem: expenses,
      cartoes: cards,
    );
  }

  // Para compatibilidade com código legado
  factory TravelExpensesInfoModel.onlyExpenses(List<TravelExpenseModel> expenses) {
    return TravelExpensesInfoModel(
      despesasdeviagem: expenses,
      cartoes: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'despesasdeviagem': (despesasdeviagem as List<TravelExpenseModel>)
          .map((expense) => expense.toJson())
          .toList(),
      'cartoes': (cartoes as List<TravelCardModel>)
          .map((card) => card.toJson())
          .toList(),
    };
  }
}