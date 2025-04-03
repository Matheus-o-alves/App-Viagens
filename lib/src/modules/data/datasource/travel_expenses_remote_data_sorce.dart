import 'package:connectivity_plus/connectivity_plus.dart';
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
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available');
      }

      final Map<String, dynamic> jsonData = mockPaymentsJson;

      final expenses = (jsonData['travelExpenses'] as List)
          .map((e) {
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

      final infoModel = TravelExpensesInfoModel(
        despesasdeviagem: expenses,
        cartoes: cards,
      );

      await syncWithRemote(infoModel.toJson());

      return infoModel;
    } catch (e) {
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
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for syncing');
      }

      await localDataSource.syncWithRemote(remoteData);
    } catch (e) {
      if (e is ConnectionException) {
        rethrow;
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
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for saving expense');
      }

      final savedId = await localDataSource.saveTravelExpense(expense);
      return savedId;
    } catch (e) {
      if (e is ConnectionException) {
        rethrow;
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
      final hasConnectivity = await _checkConnectivity();
      if (!hasConnectivity) {
        throw ConnectionException(message: 'No internet connection available for deleting expense');
      }

      return await localDataSource.deleteTravelExpense(id);
    } catch (e) {
      if (e is ConnectionException) {
        rethrow;
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
      final localExpense = await localDataSource.getTravelExpenseById(id);
      if (localExpense != null) return localExpense;

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
        rethrow;
      }

      throw ServerException(
        message: 'Failed to get travel expense by id: $e',
        statusCode: 500,
      );
    }
  }

}
