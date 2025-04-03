import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../../infra/database/database_helper.dart';
import '../../infra/datasource/travel_expenses_local_data_source.dart'
    show TravelExpensesLocalDataSource;
import '../data.dart';

import '../model/travels/travel_card_model.dart';

class TravelExpensesLocalDataSourceImpl
    implements TravelExpensesLocalDataSource {
  final DatabaseHelper _databaseHelper;

  TravelExpensesLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  @override
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
    try {
      final expenses = await _databaseHelper.getAllTravelExpenses();
      final cards = await _databaseHelper.getAllTravelCards();
      debugPrint('🔍 Cartões recuperados do banco (${cards.length}):');
      for (var card in cards) {
        debugPrint(card.toJson().toString());
      }
      return TravelExpensesInfoModel(
        despesasdeviagem: expenses,
        cartoes: cards,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to get travel info from database: $e',
      );
    }
  }

  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense) async {
    try {
      if (expense.id != 0) {
        return await _databaseHelper.updateTravelExpense(expense);
      } else {
        return await _databaseHelper.insertTravelExpense(expense);
      }
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to save expense to database: $e',
      );
    }
  }

  @override
  Future<int> deleteTravelExpense(int id) async {
    try {
      return await _databaseHelper.deleteTravelExpense(id);
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to delete expense from database: $e',
      );
    }
  }

  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    try {
      return await _databaseHelper.getTravelExpenseById(id);
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to get expense by id from database: $e',
      );
    }
  }

@override
Future<void> syncWithRemote(Map<String, dynamic> remoteData) async {
  try {
    debugPrint('🔍 Dados recebidos para sincronização: $remoteData');
    
    // Adicione logs detalhados
    debugPrint('🏦 Chaves no remoteData: ${remoteData.keys}');
    
    final infoModel = TravelExpensesInfoModel.fromJson(remoteData);
    
    debugPrint('🔢 Despesas a serem inseridas: ${infoModel.despesasdeviagem.length}');
    debugPrint('💳 Cartões a serem inseridos: ${infoModel.cartoes.length}');
    
    // Log detalhado dos cartões
    for (var card in infoModel.cartoes) {
      debugPrint('🃏 Cartão a ser inserido: ${card.toJson()}');
    }

    await _databaseHelper.batchInsertExpenses(
      infoModel.despesasdeviagem.map((e) => e as TravelExpenseModel).toList(),
    );
    debugPrint('✅ batchInsertExpenses concluído com sucesso');

    await _databaseHelper.batchInsertCards(
      infoModel.cartoes.map((e) => e as TravelCardModel).toList(),
    );
    debugPrint('✅ batchInsertCards concluído com sucesso');
  } catch (e, stackTrace) {
    debugPrint('❌ Erro na sincronização: $e');
    debugPrint('🚨 Stack trace: $stackTrace');
    throw DatabaseException(message: 'Failed to sync with remote: $e');
  }
}
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException({required this.message});
}
