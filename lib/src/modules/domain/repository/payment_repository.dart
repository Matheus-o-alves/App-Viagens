import 'package:dartz/dartz.dart';

import '../../../exports.dart';


abstract class TravelExpensesRepository {
  Future<Either<Failure, TravelExpensesInfoEntity>> getTravelExpensesInfo();
  
  Future<Either<Failure, List<dynamic>>> getTravelExpenses();
  
  Future<Either<Failure, List<dynamic>>> getTravelCards();
  
  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense);
  Future<Either<Failure, int>> deleteTravelExpense(int id);
  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id);
}