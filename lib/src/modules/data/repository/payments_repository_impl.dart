// data/repositories/travel_expenses_repository_impl.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart' as ConnectivityResult;
import '../../../core/core.dart';
import '../../domain/domain.dart';
import '../../infra/datasource/travel_expenses_data_source.dart';
import '../data.dart';
import '../datasource/travel_expenses_local_data_source.dart';

class TravelExpensesRepositoryImpl implements TravelExpensesRepository {
  final TravelExpensesRemoteDataSource _remoteDataSource;
  final TravelExpensesLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  const TravelExpensesRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  @override
  Future<Either<Failure, List<TravelExpenseEntity>>> getTravelExpenses() async {
    try {
      // Primeiro obtém os dados locais
      final localExpenses = await _localDataSource.getTravelExpensesInfo();
      
      // Tenta atualizar com dados remotos se houver conexão
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          final remoteExpenses = await _remoteDataSource.getTravelExpensesInfo();
          
          // Sincroniza os dados remotos com o banco local
          if (remoteExpenses.travelExpenses.isNotEmpty) {
            await _localDataSource.syncWithRemote(
              remoteExpenses.travelExpenses.map((e) => e as TravelExpenseModel).toList()
            );
            
            // Retorna os dados atualizados do banco local
            final updatedLocalExpenses = await _localDataSource.getTravelExpensesInfo();
            return Right(updatedLocalExpenses.travelExpenses);
          }
        } catch (e) {
          // Se falhar a obtenção dos dados remotos, simplesmente continuamos com os dados locais
          print('Failed to fetch remote data: $e');
        }
      }
      
      return Right(localExpenses.travelExpenses);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(error: e));
    }
  }

  Future<Either<Failure, int>> saveTravelExpense(TravelExpenseEntity expense) async {
    try {
      final expenseModel = expense as TravelExpenseModel;
      final result = await _localDataSource.saveTravelExpense(expenseModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(error: e));
    }
  }

  Future<Either<Failure, int>> deleteTravelExpense(int id) async {
    try {
      final result = await _localDataSource.deleteTravelExpense(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(error: e));
    }
  }

  Future<Either<Failure, TravelExpenseEntity?>> getTravelExpenseById(int id) async {
    try {
      final result = await _localDataSource.getTravelExpenseById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(GenericFailure(error: e));
    }
  }
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException({required this.message});
}