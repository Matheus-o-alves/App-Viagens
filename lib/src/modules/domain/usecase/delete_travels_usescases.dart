// domain/usecases/delete_travel_expense_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

class DeleteTravelExpenseUseCase implements UseCase<int, int> {
  final TravelExpensesRepository _repository;

  DeleteTravelExpenseUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(int id) async {
    return await _repository.deleteTravelExpense(id);
  }
}
