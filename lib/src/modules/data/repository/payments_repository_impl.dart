// data/repositories/travel_expenses_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../../domain/domain.dart';
import '../../infra/datasource/travel_expenses_data_source.dart';
import '../data.dart';

class TravelExpensesRepositoryImpl implements TravelExpensesRepository {
  final TravelExpensesDataSource _datasource;

  const TravelExpensesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses() async {
    try {
      final expensesInfo = await _datasource.getTravelExpensesInfo();
      return Right(expensesInfo.travelExpenses);
    } catch (e) {
      return Left(GenericFailure(error: e));
    }
  }
}
