import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../exports.dart';
import '../../infra/datasource/travel_expenses_local_data_source.dart';
import '../../infra/datasource/travel_expenses_remote_data_source.dart';
import '../model/travels/travel_card_model.dart';

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
  
  @override
  String toString() {
    return 'ServerException: $message (Status code: $statusCode)';
  }
}

class ConnectionException implements Exception {
  final String message;
  
  ConnectionException({required this.message});
  
  @override
  String toString() {
    return 'ConnectionException: $message';
  }
}

class TravelExpensesRemoteDataSourceImpl implements TravelExpensesRemoteDataSource {
  final http.Client client;
  final TravelExpensesLocalDataSource localDataSource;
  final Connectivity connectivity;

  TravelExpensesRemoteDataSourceImpl({
    required this.client, 
    required this.localDataSource,
    required this.connectivity,
  });

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi) || 
           connectivityResult.contains(ConnectivityResult.mobile) ||
           connectivityResult.contains(ConnectivityResult.ethernet);
  }

@override
Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
  try {
    // Verificar conectividade primeiro
    final hasConnectivity = await _checkConnectivity();
    if (!hasConnectivity) {
      debugPrint('⚠️ Sem conexão com a internet');
      throw ConnectionException(message: 'No internet connection available');
    }
    
    // Simulando acesso à API com dados mockados
    final Map<String, dynamic> jsonData = mockPaymentsJson;
    
    debugPrint('🔍 Dados JSON originais: $jsonData');
    
    // Log das chaves do JSON
    debugPrint('🔑 Chaves no JSON: ${jsonData.keys}');

    final expenses = (jsonData['travelExpenses'] as List)
        .map((e) {
          debugPrint('💸 Expense JSON: $e');
          return TravelExpenseModel(
            id: e['id'] ?? 0,
            expenseDate: DateTime.parse(e['expenseDate']),
            description: e['description'] ?? '',
            categoria: e['category'] ?? e['categoria'] ?? '',
            quantidade: (e['amount'] ?? e['quantidade'] ?? 0.0).toDouble(),
            reembolsavel: e['reimbursable'] ?? e['reembolsavel'] ?? false,
            isReimbursed: e['isReimbursed'] ?? false,
            status: e['status'] ?? '',
            paymentMethod: e['paymentMethod'] ?? '',
          );
        })
        .toList();

    final cards = (jsonData['cards'] as List)
        .map((e) {
          debugPrint('💳 Card JSON: $e');
          return TravelCardModel(
            id: e['id'] ?? 0,
            nome: e['name'] ?? e['nome'] ?? '',
            numero: e['number'] ?? e['numero'] ?? '',
            titular: e['holder'] ?? e['titular'] ?? '',
            validade: e['validThru'] ?? e['validade'] ?? '',
            bandeira: e['brand'] ?? e['bandeira'] ?? '',
            limiteDisponivel: (e['availableLimit'] ?? e['limiteDisponivel'] ?? 0.0).toDouble(),
          );
        })
        .toList();

    debugPrint('📊 Número de cartões convertidos: ${cards.length}');

    final infoModel = TravelExpensesInfoModel(
      despesasdeviagem: expenses,
      cartoes: cards,
    );

    await syncWithRemote(infoModel.toJson());
    
    return infoModel;
  } catch (e, stackTrace) {
    debugPrint('❌ Erro ao obter informações de viagem: $e');
    debugPrint('🚨 Stack trace: $stackTrace');
    
    if (e is ConnectionException) {
      throw ConnectionException(message: 'Failed to load travel expenses: No internet connection');
    }
    
    throw ServerException(
      message: 'Failed to load travel expenses: $e',
      statusCode: 500,
    );
  }
}

@override
Future<void> syncWithRemote(Map<String, dynamic> remoteData) async {
  try {
    // Verificar conectividade primeiro
    final hasConnectivity = await _checkConnectivity();
    if (!hasConnectivity) {
      debugPrint('⚠️ Sem conexão com a internet durante a sincronização');
      throw ConnectionException(message: 'No internet connection available for syncing');
    }
    
    await localDataSource.syncWithRemote(remoteData);
    debugPrint('✅ Sincronização com remoto concluída com sucesso');
  } catch (e) {
    debugPrint('❌ Erro na sincronização: $e');
    
    if (e is ConnectionException) {
      throw e;  // Repassa a exceção de conexão
    }
    
    throw ServerException(
      message: 'Failed to sync with remote: $e',
      statusCode: 500,
    );
  }
}

  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense) async {
    try {
      // Verificar conectividade primeiro
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for saving expense');
      }
      
      final savedId = await localDataSource.saveTravelExpense(expense);
      return savedId;
    } catch (e) {
      if (e is ConnectionException) {
        throw e;
      }
      
      throw ServerException(
        message: 'Failed to save travel expense: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<int> deleteTravelExpense(int id) async {
    try {
      // Verificar conectividade primeiro
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for deleting expense');
      }
      
      return await localDataSource.deleteTravelExpense(id);
    } catch (e) {
      if (e is ConnectionException) {
        throw e;
      }
      
      throw ServerException(
        message: 'Failed to delete travel expense: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    try {
      // Primeiro tenta local para funcionar offline
      final localExpense = await localDataSource.getTravelExpenseById(id);
      if (localExpense != null) return localExpense;

      // Se não encontrar local, verifica conectividade antes de consultar remotamente
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for fetching expense');
      }

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
      if (e is ConnectionException) {
        throw e;
      }
      
      throw ServerException(
        message: 'Failed to get travel expense by id: $e',
        statusCode: 500,
      );
    }
  }

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
            debugPrint('❌ Erro ao converter despesa: $ex');
            return {};
          }
        })
        .where((map) => map.isNotEmpty)
        .toList();

    final cartoes = entity.cartoes
        .map((e) {
          try {
            return (e is TravelCardModel)
                ? e.toJson()
                : {
                    'id': e.id,
                    'nome': e.nome,
                    'numero': e.numero,
                    'titular': e.titular,
                    'validade': e.validade,
                    'bandeira': e.bandeira,
                    'limiteDisponivel': e.limiteDisponivel,
                  };
          } catch (ex) {
            debugPrint('❌ Erro ao converter cartão: $ex');
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