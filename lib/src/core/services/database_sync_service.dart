import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _connectivity = connectivity;

  void initialize() {
    if (_isInitialized) {
      return;
    }

    _checkAndSync();

    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen(
      (_) => _checkAndSync(),
      onError: (error) {},
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

      if (results.any((r) => r != ConnectivityResult.none)) {
        await syncData();
      }
    } catch (_) {}
  }

  Future<void> syncData() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    try {
      final remoteExpensesInfo = await _remoteDataSource.getTravelExpensesInfo();

      final syncData = _convertEntityToSyncData(remoteExpensesInfo);

      await _localDataSource.syncWithRemote(syncData);

      _notifyBlocToRefresh();

      onSyncComplete?.call();
    } catch (_) {
    } finally {
      _isSyncing = false;
    }
  }


  void _notifyBlocToRefresh() {
    try {
      if (_sl.isRegistered<TravelExpensesBloc>()) {
        _sl<TravelExpensesBloc>().add(const FetchTravelExpenses());
      }
    } catch (_) {}
  }

  Map<String, dynamic> _convertEntityToSyncData(
    TravelExpensesInfoEntity entity,
  ) {
    final despesas = _convertExpenses(entity.despesasdeviagem);
    final cartoes = _convertCards(entity.cartoes);

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
          } catch (_) {
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
          } catch (_) {
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
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _isInitialized = false;
  }
}
