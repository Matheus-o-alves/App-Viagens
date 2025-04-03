import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

class GetTravelExpensesUseCase
    implements UseCase<TravelExpensesInfoEntity, NoParams> {
  final TravelExpensesRepository _repository;

  GetTravelExpensesUseCase(this._repository);

  @override
  Future<Either<Failure, TravelExpensesInfoEntity>> call([NoParams? params]) async {
    return await _repository.getTravelExpensesInfo();
  }
}
