import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../exports.dart';
import '../../modules/data/data.dart';
import '../../modules/data/datasource/travel_expenses_local_data_source.dart';

import '../../modules/data/model/travels/travel_card_model.dart' show TravelCardModel;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../modules/data/data.dart';
import '../../modules/data/datasource/travel_expenses_local_data_source.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../modules/data/data.dart';
import '../../modules/data/datasource/travel_expenses_local_data_source.dart';
import '../../modules/infra/datasource/travel_expenses_local_data_source.dart';
import '../../modules/infra/datasource/travel_expenses_remote_data_source.dart';


class DatabaseSyncService {
  final TravelExpensesLocalDataSource _localDataSource;
  final TravelExpensesRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;
  
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  DatabaseSyncService({
    required TravelExpensesLocalDataSource localDataSource,
    required TravelExpensesRemoteDataSource remoteDataSource,
    required Connectivity connectivity,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _connectivity = connectivity;
  
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Se houver pelo menos um tipo de conexão ativa
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncData();
      }
    });
    
    // Verificar o estado inicial de conectividade e sincronizar se estiver conectado
    _connectivity.checkConnectivity().then((List<ConnectivityResult> results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncData();
      }
    });
  }
  
  Future<void> syncData() async {
    try {
      // Buscar dados da API remota
      final TravelExpensesInfoEntity remoteExpensesInfo = await _remoteDataSource.getTravelExpensesInfo();
      
      // Converter a entidade para um formato que pode ser sincronizado
      final Map<String, dynamic> syncData = _convertEntityToSyncData(remoteExpensesInfo);
      
      // Sincronizar com o banco de dados local
      await _localDataSource.syncWithRemote(syncData);
      
      debugPrint('Database sync completed successfully');
    } catch (e) {
      debugPrint('Error during database sync: $e');
    }
  }
  
  Map<String, dynamic> _convertEntityToSyncData(TravelExpensesInfoEntity entity) {
    return {
      'despesasdeviagem': entity.despesasdeviagem.map((e) {
        if (e is TravelExpenseModel) {
          return e.toJson();
        } else {
          // Fallback para quando não é TravelExpenseModel
          // Isso deve ser raro, mas é necessário para garantir a robustez do código
          return {
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
        }
      }).toList(),
      
      'cartoes': entity.cartoes.map((e) {
        if (e is TravelCardModel) {
          return e.toJson();
        } else {
          // Fallback para quando não é TravelCardModel
          return {
            'id': e.id,
            'nome': e.nome,
            'numero': e.numero,
            'titular': e.titular,
            'validade': e.validade,
            'bandeira': e.bandeira,
            'limiteDisponivel': e.limiteDisponivel,
          };
        }
      }).toList(),
    };
  }
  
  // Forçar sincronização manual
  Future<bool> forceSyncData() async {
    try {
      await syncData();
      return true;
    } catch (e) {
      debugPrint('Manual sync failed: $e');
      return false;
    }
  }
  
  void dispose() {
    _connectivitySubscription.cancel();
  }
}