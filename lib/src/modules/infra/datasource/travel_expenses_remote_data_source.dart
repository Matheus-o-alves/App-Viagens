import '../../../exports.dart';

abstract class TravelExpensesRemoteDataSource implements TravelExpensesDataSource {
  @override
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
  
  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense);
  
  @override
  Future<int> deleteTravelExpense(int id);
  
  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id);
  
  @override
  Future<void> syncWithRemote(Map<String, dynamic> remoteData);
}
