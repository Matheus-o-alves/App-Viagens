import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

// Importações organizadas
import '../../modules/data/data.dart';

import '../../modules/data/model/travels/travel_card_model.dart' show TravelCardModel;
import '../../modules/domain/entity/payments_info_entity.dart';
import '../../modules/infra/datasource/travel_expenses_local_data_source.dart';
import '../../modules/infra/datasource/travel_expenses_remote_data_source.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

// Importações organizadas
import '../../modules/data/data.dart';
import '../../modules/data/model/travels/travel_card_model.dart' show TravelCardModel;
import '../../modules/domain/entity/payments_info_entity.dart';
import '../../modules/infra/datasource/travel_expenses_local_data_source.dart';
import '../../modules/infra/datasource/travel_expenses_remote_data_source.dart';
import '../../modules/presentation/bloc/homePageBloc/home_page_bloc.dart';
import '../../modules/presentation/bloc/homePageBloc/home_page_event.dart';

class DatabaseSyncService {
  final TravelExpensesLocalDataSource _localDataSource;
  final TravelExpensesRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;
   Function? onSyncComplete;
  
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final GetIt _sl = GetIt.instance;
  
  DatabaseSyncService({
    required TravelExpensesLocalDataSource localDataSource,
    required TravelExpensesRemoteDataSource remoteDataSource,
    required Connectivity connectivity,
    this.onSyncComplete,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _connectivity = connectivity;
  
  void initialize() {
    debugPrint('DatabaseSyncService: Inicializando...');
    _checkAndSync();
    
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      debugPrint('DatabaseSyncService: Conectividade alterada: $results');
      _checkAndSync();
    });
  }
  void initializeWithCallback(Function callback) {
  onSyncComplete = callback;
  initialize();
}

  void _checkAndSync() async {
    final results = await _connectivity.checkConnectivity();
    debugPrint('DatabaseSyncService: Status de conectividade: $results');
    if (results.any((result) => result != ConnectivityResult.none)) {
      syncData();
    } else {
      debugPrint('DatabaseSyncService: Sem conexão disponível.');
    }
  }
  
  Future<void> syncData() async {
    try {
      debugPrint('DatabaseSyncService: Iniciando sincronização...');
      
      // Buscar dados da API remota
      final remoteExpensesInfo = await _remoteDataSource.getTravelExpensesInfo();
      debugPrint('DatabaseSyncService: Dados obtidos da API:');
      debugPrint('- Despesas: ${remoteExpensesInfo.despesasdeviagem.length}');
      debugPrint('- Cartões: ${remoteExpensesInfo.cartoes.length}');
      
      // Converter a entidade para um formato que pode ser sincronizado
      final syncData = _convertEntityToSyncData(remoteExpensesInfo);
      debugPrint('DatabaseSyncService: Dados convertidos para sincronização');
      
      // Sincronizar com o banco de dados local
      await _localDataSource.syncWithRemote(syncData);
      
      debugPrint('DatabaseSyncService: Sincronização concluída com sucesso');
      
      // Notificar o bloc para atualizar os dados após a sincronização
      _notifyBlocToRefresh();
      debugPrint('🧾 Dados a serem salvos:');
for (var e in remoteExpensesInfo.despesasdeviagem) {
  if (e is TravelExpenseModel) {
    debugPrint(e.toDatabaseMap().toString());
  } else {
    debugPrint({
      'id': e.id,
      'expenseDate': e.expenseDate.toIso8601String(),
      'description': e.description,
      'categoria': e.categoria,
      'quantidade': e.quantidade,
      'reembolsavel': e.reembolsavel,
      'isReimbursed': e.isReimbursed,
      'status': e.status,
      'paymentMethod': e.paymentMethod,
    }.toString());
  }
}

      // Chamar o callback personalizado, se fornecido
      if (onSyncComplete != null) {
        onSyncComplete!();
      }
    } catch (e, stackTrace) {
      debugPrint('DatabaseSyncService: Erro durante a sincronização: $e');
      debugPrint('DatabaseSyncService: Stack trace: $stackTrace');
    }
  }
  
  void _notifyBlocToRefresh() {
    try {
      if (_sl.isRegistered<TravelExpensesBloc>()) {
        debugPrint('DatabaseSyncService: Notificando TravelExpensesBloc para atualizar dados');
        _sl<TravelExpensesBloc>().add(const FetchTravelExpenses());
      } else {
        debugPrint('DatabaseSyncService: TravelExpensesBloc não está registrado, não foi possível notificar');
      }
    } catch (e) {
      debugPrint('DatabaseSyncService: Erro ao notificar o bloc: $e');
    }
  }
  
  Map<String, dynamic> _convertEntityToSyncData(TravelExpensesInfoEntity entity) {
    final despesas = entity.despesasdeviagem.map((e) {
      try {
        if (e is TravelExpenseModel) {
          return e.toJson();
        } else {
          debugPrint('DatabaseSyncService: Convertendo despesa manualmente: ID ${e.id}');
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
      } catch (ex) {
        debugPrint('DatabaseSyncService: Erro ao converter despesa: $ex');
        // Retornar um objeto vazio em caso de erro para evitar falhas na sincronização
        return {};
      }
    }).where((map) => map.isNotEmpty).toList();
    
    final cartoes = entity.cartoes.map((e) {
      try {
        if (e is TravelCardModel) {
          return e.toJson();
        } else {
          debugPrint('DatabaseSyncService: Convertendo cartão manualmente: ID ${e.id}');
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
      } catch (ex) {
        debugPrint('DatabaseSyncService: Erro ao converter cartão: $ex');
        return {};
      }
    }).where((map) => map.isNotEmpty).toList();
    
    debugPrint('DatabaseSyncService: Convertidos ${despesas.length} despesas e ${cartoes.length} cartões');
    
    return {
      'despesasdeviagem': despesas,
      'cartoes': cartoes,
    };
  }
  
  // Forçar sincronização manual
  Future<bool> forceSyncData() async {
    debugPrint('DatabaseSyncService: Iniciando sincronização forçada...');
    try {
      await syncData();
      return true;
    } catch (e) {
      debugPrint('DatabaseSyncService: Falha na sincronização manual: $e');
      return false;
    }
  }
  
  void dispose() {
    debugPrint('DatabaseSyncService: Finalizando serviço de sincronização');
    _connectivitySubscription.cancel();
  }
}