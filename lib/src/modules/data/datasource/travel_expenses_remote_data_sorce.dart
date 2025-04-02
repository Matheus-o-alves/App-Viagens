

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onfly_viagens_app/src/modules/domain/entity/payments_info_entity.dart';
import 'package:onfly_viagens_app/src/modules/infra/datasource/travel_expenses_data_source.dart' show TravelExpensesDataSource;

import '../../../core/base/base.dart';
import '../../infra/datasource/travel_expenses_remote_data_source.dart';
import '../data.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../infra/datasource/travel_expenses_data_source.dart';

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}


class TravelExpensesRemoteDataSourceImpl implements TravelExpensesRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.mocki.io/v2/ezwra77r'; // Substitua pela URL real da sua API

  TravelExpensesRemoteDataSourceImpl({required this.client});

  @override
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return TravelExpensesInfoModel.fromJson(jsonData);
      } else {
        throw ServerException(
          message: 'Failed to load travel expenses',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Connection error: $e',
        statusCode: 503, // Service Unavailable
      );
    }
  }

  @override
  Future<int> saveTravelExpense(TravelExpenseModel expense) async {
    try {
      final url = expense.id == 0 
          ? Uri.parse('$baseUrl/travel-expenses') 
          : Uri.parse('$baseUrl/travel-expenses/${expense.id}');
      
      final method = expense.id == 0 ? 'POST' : 'PUT';
      
      final response = await (method == 'POST' 
          ? client.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(expense.toJson()),
            )
          : client.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(expense.toJson()),
            ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['id'] ?? expense.id;
      } else {
        throw ServerException(
          message: 'Failed to save travel expense',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Connection error: $e',
        statusCode: 503, // Service Unavailable
      );
    }
  }

  @override
  Future<int> deleteTravelExpense(int id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/travel-expenses/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return id;
      } else {
        throw ServerException(
          message: 'Failed to delete travel expense',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Connection error: $e',
        statusCode: 503, // Service Unavailable
      );
    }
  }

  @override
  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/travel-expenses/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return TravelExpenseModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw ServerException(
          message: 'Failed to get travel expense by id',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Connection error: $e',
        statusCode: 503, // Service Unavailable
      );
    }
  }

  @override
  Future<void> syncWithRemote(Map<String, dynamic> remoteData) async {
    // Para a implementação remota, não é necessário sincronizar dados locais
    // com o servidor, pois os dados já vêm do servidor
    return;
  }
}