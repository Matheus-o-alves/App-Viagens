import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';



class GetTravelExpensesUseCase implements UseCase<TravelExpensesInfoEntity, NoParams> {
  final TravelExpensesRepository repository;

  GetTravelExpensesUseCase(this.repository);

  @override
  Future<Either<Failure, TravelExpensesInfoEntity>> call(NoParams params) async {
    return await repository.getTravelExpensesInfo();
  }
}

class GetTravelExpensesListUseCase implements UseCase<List<dynamic>, NoParams> {
  final TravelExpensesRepository repository;

  GetTravelExpensesListUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(NoParams params) async {
    return await repository.getTravelExpenses();
  }
}

class GetTravelCardsUseCase implements UseCase<List<dynamic>, NoParams> {
  final TravelExpensesRepository repository;

  GetTravelCardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(NoParams params) async {
    return await repository.getTravelCards();
  }
}