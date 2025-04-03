import 'package:http/http.dart' as http;

import '../../../exports.dart';
import '../../infra/datasource/travel_expenses_local_data_source.dart';
import '../../infra/datasource/travel_expenses_remote_data_source.dart';
import '../model/travels/travel_card_model.dart';

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}

class TravelExpensesRemoteDataSourceImpl implements TravelExpensesRemoteDataSource {
  final http.Client client;
  final TravelExpensesLocalDataSource localDataSource;

  TravelExpensesRemoteDataSourceImpl({
    required this.client, 
    required this.localDataSource
  });

@override
Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
  try {
    final Map<String, dynamic> jsonData = mockPaymentsJson;
    
    final expenses = (jsonData['travelExpenses'] as List)
        .map((e) => TravelExpenseModel(
          id: e['id'] ?? 0,
          expenseDate: DateTime.parse(e['expenseDate']),
          description: e['description'] ?? '',
          categoria: e['category'] ?? e['categoria'] ?? '',
          quantidade: (e['amount'] ?? e['quantidade'] ?? 0.0).toDouble(),
          reembolsavel: e['reimbursable'] ?? e['reembolsavel'] ?? false,
          isReimbursed: e['isReimbursed'] ?? false,
          status: e['status'] ?? '',
          paymentMethod: e['paymentMethod'] ?? '',
        ))
        .toList();

    final cards = (jsonData['cards'] as List)
        .map((e) => TravelCardModel(
          id: e['id'] ?? 0,
          nome: e['name'] ?? e['nome'] ?? '',
          numero: e['number'] ?? e['numero'] ?? '',
          titular: e['holder'] ?? e['titular'] ?? '',
          validade: e['validThru'] ?? e['validade'] ?? '',
          bandeira: e['brand'] ?? e['bandeira'] ?? '',
          limiteDisponivel: (e['availableLimit'] ?? e['limiteDisponivel'] ?? 0.0).toDouble(),
        ))
        .toList();

    final infoModel = TravelExpensesInfoModel(
      despesasdeviagem: expenses,
      cartoes: cards,
    );

    await syncWithRemote(infoModel.toJson());
    
    return infoModel;
  } catch (e) {
    throw ServerException(
      message: 'Failed to load travel expenses: $e',
      statusCode: 500,
    );
  }
}

@override
Future<void> syncWithRemote(Map<String, dynamic> remoteData) async {
  try {
    await localDataSource.syncWithRemote(remoteData);
  } catch (e) {
    throw ServerException(
      message: 'Failed to sync with remote: $e',
      statusCode: 500,
    );
  }
}

  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense) async {
    try {
      final savedId = await localDataSource.saveTravelExpense(expense);
      return savedId;
    } catch (e) {
      throw ServerException(
        message: 'Failed to save travel expense: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<int> deleteTravelExpense(int id) async {
    try {
      return await localDataSource.deleteTravelExpense(id);
    } catch (e) {
      throw ServerException(
        message: 'Failed to delete travel expense: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    try {
      final localExpense = await localDataSource.getTravelExpenseById(id);
      if (localExpense != null) return localExpense;

      final Map<String, dynamic> jsonData = mockPaymentsJson;
      
      final expenses = jsonData['travelExpenses'] as List<dynamic>;
      final expenseData = expenses.firstWhere(
        (expense) => expense['id'] == id,
        orElse: () => null,
      );
      
      return expenseData != null 
        ? TravelExpenseModel.fromJson(expenseData) 
        : null;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get travel expense by id: $e',
        statusCode: 500,
      );
    }
  }



  // ignore: unused_element
  Map<String, dynamic> _convertEntityToSyncData(
    TravelExpensesInfoEntity entity,
  ) {
    final despesas = entity.despesasdeviagem
        .map((e) {
          try {
            return (e is TravelExpenseModel)
                ? e.toJson()
                : {
                    'id': e.id,
                    'expenseDate': e.expenseDate.toIso8601String(),
                    'description': e.description,
                    'categoria': e.categoria,
                    'quantidade': e.quantidade,
                    'reembolsavel': e.reembolsavel,
                    'isReimbursed': e.isReimbursed,
                    'status': e.status,
                    'paymentMethod': e.paymentMethod,
                  };
          } catch (ex) {
            return {};
          }
        })
        .where((map) => map.isNotEmpty)
        .toList();

    final cartoes = entity.cartoes
        .map((e) {
          try {
            return {
              'id': e.id,
              'nome': e.nome,
              'numero': e.numero,
              'titular': e.titular,
              'validade': e.validade,
              'bandeira': e.bandeira,
              'limiteDisponivel': e.limiteDisponivel,
            };
          } catch (ex) {
            return {};
          }
        })
        .where((map) => map.isNotEmpty)
        .toList();

    return {
      'despesasdeviagem': despesas, 
      'cartoes': cartoes
    };
  }
}