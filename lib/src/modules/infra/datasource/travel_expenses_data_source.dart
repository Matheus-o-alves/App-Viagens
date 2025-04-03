import '../../../exports.dart';

abstract class TravelExpensesDataSource {
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
  

  Future<int> saveTravelExpense(TravelExpenseModel expense);
  Future<int> deleteTravelExpense(int id);
  Future<TravelExpenseModel?> getTravelExpenseById(int id);
  
  Future<void> syncWithRemote(Map<String, dynamic> remoteData);
}