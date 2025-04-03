import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../modules/data/model/travels/payments.dart';
import '../../modules/data/model/travels/travel_card_model.dart';
import '../../modules/domain/entity/payments_info_entity.dart';
import '../../modules/infra/datasource/travel_expenses_local_data_source.dart';
import '../../modules/infra/datasource/travel_expenses_remote_data_source.dart';
import '../../modules/presentation/bloc/expensesPageBloc/expenses_bloc.dart';
import '../../modules/presentation/bloc/expensesPageBloc/expenses_event.dart';

class DatabaseSyncService {
  final TravelExpensesLocalDataSource _localDataSource;
  final TravelExpensesRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  Function? onSyncComplete;
  bool _isSyncing = false;
  bool _isInitialized = false;

  final GetIt _sl = GetIt.instance;

  DatabaseSyncService({
    required TravelExpensesLocalDataSource localDataSource,
    required TravelExpensesRemoteDataSource remoteDataSource,
    required Connectivity connectivity,
    this.onSyncComplete,
  }) : 
    _localDataSource = localDataSource,
    _remoteDataSource = remoteDataSource,
    _connectivity = connectivity;

  void initialize() {
    if (_isInitialized) {
      debugPrint('DatabaseSyncService: Já inicializado');
      return;
    }

    debugPrint('DatabaseSyncService: Inicializando...');
    
    _checkAndSync();
    
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen(
        (_) => _checkAndSync(),
        onError: (error) {
          debugPrint('DatabaseSyncService: Erro de conectividade: $error');
        },
        cancelOnError: false,
      );

    _isInitialized = true;
  }

  void initializeWithCallback(Function callback) {
    onSyncComplete = callback;
    initialize();
  }

  Future<void> _checkAndSync() async {
    try {
      final results = await _connectivity.checkConnectivity();
      debugPrint('DatabaseSyncService: Status de conectividade: $results');
      
      if (results.any((r) => r != ConnectivityResult.none)) {
        await syncData();
      } else {
        debugPrint('DatabaseSyncService: Sem conexão disponível.');
      }
    } catch (e) {
      debugPrint('DatabaseSyncService: Erro ao verificar conectividade: $e');
    }
  }

  Future<void> syncData() async {
    if (_isSyncing) {
      debugPrint(
        'DatabaseSyncService: Sincronização ignorada (já em andamento)',
      );
      return;
    }

    _isSyncing = true;
    try {
      debugPrint('DatabaseSyncService: Iniciando sincronização...');
      
      final remoteExpensesInfo = await _remoteDataSource.getTravelExpensesInfo();
      
      debugPrint('DatabaseSyncService: Dados obtidos da API:');
      debugPrint('- Despesas: ${remoteExpensesInfo.despesasdeviagem.length}');
      debugPrint('- Cartões: ${remoteExpensesInfo.cartoes.length}');

      final syncData = _convertEntityToSyncData(remoteExpensesInfo);
      debugPrint('DatabaseSyncService: Dados convertidos para sincronização');

      await _localDataSource.syncWithRemote(syncData);
      debugPrint('DatabaseSyncService: Sincronização concluída com sucesso');

      _notifyBlocToRefresh();

      for (var e in remoteExpensesInfo.despesasdeviagem) {
        final data = _getExpenseData(e);
        debugPrint('🧾 $data');
      }

      onSyncComplete?.call();
    } catch (e, stackTrace) {
      debugPrint('DatabaseSyncService: Erro durante a sincronização: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _isSyncing = false;
    }
  }

  Map<String, dynamic> _getExpenseData(dynamic expense) {
    return expense is TravelExpenseModel
        ? expense.toDatabaseMap()
        : {
            'id': expense.id,
            'expenseDate': expense.expenseDate.toIso8601String(),
            'description': expense.description,
            'categoria': expense.categoria,
            'quantidade': expense.quantidade,
            'reembolsavel': expense.reembolsavel,
            'isReimbursed': expense.isReimbursed,
            'status': expense.status,
            'paymentMethod': expense.paymentMethod,
          };
  }

  void _notifyBlocToRefresh() {
    try {
      if (_sl.isRegistered<TravelExpensesBloc>()) {
        debugPrint('DatabaseSyncService: Notificando TravelExpensesBloc');
        _sl<TravelExpensesBloc>().add(const FetchTravelExpenses());
      } else {
        debugPrint('DatabaseSyncService: TravelExpensesBloc não registrado');
      }
    } catch (e) {
      debugPrint('Erro ao notificar TravelExpensesBloc: $e');
    }
  }

  Map<String, dynamic> _convertEntityToSyncData(
    TravelExpensesInfoEntity entity,
  ) {
    final despesas = _convertExpenses(entity.despesasdeviagem);
    final cartoes = _convertCards(entity.cartoes);

    debugPrint(
      'Convertidos ${despesas.length} despesas e ${cartoes.length} cartões',
    );

    return {'despesasdeviagem': despesas, 'cartoes': cartoes};
  }

  List<Map> _convertExpenses(List<dynamic> expenses) {
    return expenses
        .map((e) {
          try {
            return e is TravelExpenseModel
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
            debugPrint('Erro ao converter despesa: $ex');
            return {};
          }
        })
        .where((map) => map.isNotEmpty)
        .toList();
  }

  List<Map> _convertCards(List<dynamic> cards) {
    return cards
        .map((e) {
          try {
            return e is TravelCardModel
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
            debugPrint('Erro ao converter cartão: $ex');
            return {};
          }
        })
        .where((map) => map.isNotEmpty)
        .toList();
  }

  Future<bool> forceSyncData() async {
    try {
      await syncData();
      return true;
    } catch (e) {
      debugPrint('Falha na sincronização forçada: $e');
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _isInitialized = false;
  }
}