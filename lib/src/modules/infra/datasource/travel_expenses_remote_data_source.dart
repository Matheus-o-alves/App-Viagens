import '../../../exports.dart';

abstract class TravelExpensesRemoteDataSource implements TravelExpensesDataSource {
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
  
  // Os métodos abaixo são implementados diferentemente por cada subclasse
  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense);
  
  @override
  Future<int> deleteTravelExpense(int id);
  
  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id);
  
  @override
  Future<void> syncWithRemote(Map<String, dynamic> remoteData);
}
