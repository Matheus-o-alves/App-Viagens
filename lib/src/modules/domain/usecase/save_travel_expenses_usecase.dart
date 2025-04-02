// domain/usecases/save_travel_expense_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

class SaveTravelExpenseUseCase implements UseCase<int, TravelExpenseEntity> {
  final TravelExpensesRepository _repository;

  SaveTravelExpenseUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(TravelExpenseEntity params) async {
    return await _repository.saveTravelExpense(params);
  }
}
