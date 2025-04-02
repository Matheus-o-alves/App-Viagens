// domain/datasources/travel_expenses_data_source.dart
import '../../domain/domain.dart';

abstract class TravelExpensesDataSource {
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo();
}
