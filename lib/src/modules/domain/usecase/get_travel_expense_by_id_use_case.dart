import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

class GetTravelExpenseByIdUseCase implements UseCase<TravelExpenseEntity?, int> {
  final TravelExpensesRepository _repository;

  GetTravelExpenseByIdUseCase(this._repository);

  @override
  Future<Either<Failure, TravelExpenseEntity?>> call(int id) async {
    return await _repository.getTravelExpenseById(id);
  }
}