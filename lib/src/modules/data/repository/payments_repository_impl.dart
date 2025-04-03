import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../exports.dart';
import '../../domain/entity/travel_card_entity.dart';
import '../model/travels/travel_card_model.dart';

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
  Future<Either<Failure, List<dynamic>>> getTravelExpenses() async {
    try {
      final result = await _dataSource.getTravelExpensesInfo();
      
      debugPrint('📋 Retornando lista de despesas (tipo: ${result.despesasdeviagem.runtimeType})');
      return Right(result.despesasdeviagem);
    } on Exception catch (e) {
      debugPrint('❌ Erro ao obter despesas: $e');
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
  Future<Either<Failure, List<dynamic>>> getTravelCards() async {
    try {
      final result = await _dataSource.getTravelExpensesInfo();
      
      debugPrint('💳 Retornando lista de cartões (tipo: ${result.cartoes.runtimeType})');
      return Right(result.cartoes);
    } on Exception catch (e) {
      debugPrint('❌ Erro ao obter cartões: $e');
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
      // Garantir que o objeto é do tipo TravelExpenseModel ou convertê-lo
      final TravelExpenseModel expenseModel = expense is TravelExpenseModel
          ? expense
          : TravelExpenseModel(
              id: expense.id,
              expenseDate: expense.expenseDate,
              description: expense.description,
              categoria: expense.categoria,
              quantidade: expense.quantidade,
              reembolsavel: expense.reembolsavel,
              isReimbursed: expense.isReimbursed,
              status: expense.status,
              paymentMethod: expense.paymentMethod,
            );
      
      final id = await _dataSource.saveTravelExpense(expenseModel);
      return Right(id);
    } on Exception catch (e) {
      debugPrint('❌ Erro ao salvar despesa: $e');
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
      debugPrint('❌ Erro ao excluir despesa: $e');
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
      debugPrint('❌ Erro ao obter despesa por ID: $e');
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