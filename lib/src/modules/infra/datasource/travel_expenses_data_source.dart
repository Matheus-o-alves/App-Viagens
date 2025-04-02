// domain/datasources/travel_expenses_data_source.dart
import '../../../exports.dart';
import '../../domain/domain.dart';

abstract class TravelExpensesDataSource {
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
  
  // Métodos para manipulação de despesas individuais
  Future<int> saveTravelExpense(TravelExpenseModel expense);
  Future<int> deleteTravelExpense(int id);
  Future<TravelExpenseModel?> getTravelExpenseById(int id);
  
  // Método para sincronização
  Future<void> syncWithRemote(Map<String, dynamic> remoteData);
}