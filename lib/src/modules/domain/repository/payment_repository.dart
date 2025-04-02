// domain/repositories/travel_expenses_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

abstract class TravelExpensesRepository {
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses();
  
  // Novos métodos para CRUD
  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense);
  Future<Either<Failure, int>> deleteTravelExpense(int id);
  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id);
}
