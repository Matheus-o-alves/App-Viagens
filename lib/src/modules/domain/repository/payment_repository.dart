// domain/repositories/travel_expenses_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/core.dart';
import '../domain.dart';

abstract class TravelExpensesRepository {
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses();
}
