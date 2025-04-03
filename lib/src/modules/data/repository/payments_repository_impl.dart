import 'package:dartz/dartz.dart';

import '../../../exports.dart';
import '../../domain/entity/travel_card_entity.dart';


class TravelExpensesRepositoryImpl implements TravelExpensesRepository {
  final TravelExpensesDataSource _dataSource;

  TravelExpensesRepositoryImpl({required TravelExpensesDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, TravelExpensesInfoEntity>> getTravelExpensesInfo() async {
    try {
      final result = await _dataSource.getTravelExpensesInfo();
      return Right(result);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses() async {
    try {
      final result = await _dataSource.getTravelExpensesInfo();
      return Right(result.despesasdeviagem);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TravelCardEntity>>> getTravelCards() async {
    try {
      final result = await _dataSource.getTravelExpensesInfo();
      return Right(result.cartoes);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense) async {
    try {
      final TravelExpenseModel expenseModel = expense as TravelExpenseModel;
      final id = await _dataSource.saveTravelExpense(expenseModel);
      return Right(id);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTravelExpense(int id) async {
    try {
      final result = await _dataSource.deleteTravelExpense(id);
      return Right(result);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id) async {
    try {
      final expense = await _dataSource.getTravelExpenseById(id);
      return Right(expense);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}