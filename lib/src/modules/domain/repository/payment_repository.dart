import 'package:dartz/dartz.dart';
import '../../../exports.dart';
import '../entity/travel_card_entity.dart';


abstract class TravelExpensesRepository {
  Future<Either<Failure, TravelExpensesInfoEntity>> getTravelExpensesInfo();
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses();
  Future<Either<Failure, List<TravelCardEntity>>> getTravelCards();
  
  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense);
  Future<Either<Failure, int>> deleteTravelExpense(int id);
  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id);
}