// data/datasources/travel_expenses_local_data_source.dart
import 'package:sqflite/sqlite_api.dart';

import '../../../core/core.dart';

import '../../domain/domain.dart';
import '../../infra/database/database_helper.dart';
import '../../infra/datasource/travel_expenses_data_source.dart';
import '../data.dart';


class TravelExpensesLocalDataSource implements TravelExpensesDataSource {
  final DatabaseHelper _databaseHelper;

  TravelExpensesLocalDataSource({required DatabaseHelper databaseHelper}) 
      : _databaseHelper = databaseHelper;

  @override
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
    try {
      final expenses = await _databaseHelper.getAllTravelExpenses();
      return TravelExpensesInfoModel(travelExpenses: expenses);
    } catch (e) {
      throw DatabaseException(message: 'Failed to get expenses from database: $e');
    }
  }

  Future<int> saveTravelExpense(TravelExpenseModel expense) async {
    try {
      if (expense.id != 0) {
        return await _databaseHelper.updateTravelExpense(expense);
      } else {
        return await _databaseHelper.insertTravelExpense(expense);
      }
    } catch (e) {
      throw DatabaseException(message: 'Failed to save expense to database: $e');
    }
  }

  Future<int> deleteTravelExpense(int id) async {
    try {
      return await _databaseHelper.deleteTravelExpense(id);
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete expense from database: $e');
    }
  }

  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    try {
      return await _databaseHelper.getTravelExpenseById(id);
    } catch (e) {
      throw DatabaseException(message: 'Failed to get expense by id from database: $e');
    }
  }

  Future<void> syncWithRemote(List<TravelExpenseModel> remoteExpenses) async {
    try {
      await _databaseHelper.batchInsert(remoteExpenses);
    } catch (e) {
      throw DatabaseException(message: 'Failed to sync expenses with remote: $e');
    }
  }
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException({required this.message});
}