import 'package:dartz/dartz.dart';

import '../../../exports.dart';
import '../entity/payments_info_entity.dart';
import '../entity/travel_card_entity.dart';


abstract class TravelExpensesRepository {
  Future<Either<Failure, TravelExpensesInfoEntity>> getTravelExpensesInfo();
  
  // Modificado para aceitar List<dynamic> em vez de List<TravelExpenseEntity>
  Future<Either<Failure, List<dynamic>>> getTravelExpenses();
  
  // Modificado para aceitar List<dynamic> em vez de List<TravelCardEntity>
  Future<Either<Failure, List<dynamic>>> getTravelCards();
  
  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense);
  Future<Either<Failure, int>> deleteTravelExpense(int id);
  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id);
}