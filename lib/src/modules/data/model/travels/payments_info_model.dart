// data/models/travel_expenses_info_model.dart
import '../../../domain/domain.dart';
import '../../data.dart';

class TravelExpensesInfoModel extends TravelExpensesInfoEntity {
  const TravelExpensesInfoModel({
    required List<TravelExpenseEntity> travelExpenses,
  }) : super(travelExpenses: travelExpenses);

  factory TravelExpensesInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelExpensesInfoModel(
      travelExpenses: json['travelExpenses'] != null
          ? (json['travelExpenses'] as List)
              .map<TravelExpenseEntity>((item) => TravelExpenseModel.fromJson(item))
              .toList()
          : [],
    );
  }

  factory TravelExpensesInfoModel.empty() => const TravelExpensesInfoModel(travelExpenses: []);

  Map<String, dynamic> toJson() {
    return {
      'travelExpenses': travelExpenses.map((expense) {
        if (expense is TravelExpenseModel) {
          return expense.toJson();
        }
        return {};
      }).toList(),
    };
  }
}
