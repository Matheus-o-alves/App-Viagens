// domain/usecases/get_travel_expenses_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

class GetTravelExpensesUseCase implements UseCase<List<TravelExpenseEntity>, NoParams> {
  final TravelExpensesRepository _repository;

  GetTravelExpensesUseCase(this._repository);

  @override
  Future<Either<Failure, List<TravelExpenseEntity>>> call([NoParams? params]) async {
    final result = await _repository.getTravelExpenses();

    if (result.isRight()) {
      final expenses = result.asRight();
      
      // Ordenar por data, sem filtrar
      expenses.sort((a, b) => a.expenseDate.compareTo(b.expenseDate));

      return Right(expenses);
    } else {
      return result.map((_) => <TravelExpenseEntity>[]);
    }
  }
}