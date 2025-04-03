import '../../../exports.dart';


import 'travel_expenses_data_source.dart';

abstract class TravelExpensesLocalDataSource implements TravelExpensesDataSource {
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
  Future<int> saveTravelExpense(TravelExpenseModel expense);
  Future<int> deleteTravelExpense(int id);
  Future<TravelExpenseModel?> getTravelExpenseById(int id);
  Future<void> syncWithRemote(Map<String, dynamic> remoteData);
}