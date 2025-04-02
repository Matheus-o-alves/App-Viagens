// core/services/database_sync_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../modules/data/data.dart';
import '../../modules/data/datasource/travel_expenses_local_data_source.dart';

class DatabaseSyncService {
  final TravelExpensesLocalDataSource _localDataSource;
  final TravelExpensesRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;
  
  // Atualize o tipo para corresponder ao tipo real retornado
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
    
    // Check initial connectivity state and sync if connected
    _connectivity.checkConnectivity().then((List<ConnectivityResult> results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncData();
      }
    });
  }
  
  Future<void> syncData() async {
    try {
      // Fetch data from remote API
      final remoteExpensesInfo = await _remoteDataSource.getTravelExpensesInfo();
      
      // Convert to list of TravelExpenseModel
      final remoteExpenses = remoteExpensesInfo.travelExpenses
          .map((e) => e as TravelExpenseModel)
          .toList();
      
      // Sync with local database
      await _localDataSource.syncWithRemote(remoteExpenses);
      
      debugPrint('Database sync completed successfully');
    } catch (e) {
      debugPrint('Error during database sync: $e');
    }
  }
  
  // Force a manual sync
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