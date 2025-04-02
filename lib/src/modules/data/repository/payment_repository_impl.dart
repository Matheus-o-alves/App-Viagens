

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onfly_viagens_app/src/modules/domain/entity/payments_info_entity.dart';
import 'package:onfly_viagens_app/src/modules/infra/datasource/travel_expenses_data_source.dart' show TravelExpensesDataSource;

import '../../../core/base/base.dart';
import '../data.dart';

class TravelExpensesRemoteDataSource implements TravelExpensesDataSource {
  final http.Client client;
  final String baseUrl = 'https://travels.free.beeceptor.com';

  TravelExpensesRemoteDataSource({required this.client});

  @override
  Future<TravelExpensesInfoEntity> getTravelExpensesInfo() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/travels'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Para debugging
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        final jsonData = json.decode(response.body);
        
        // Verifica se o JSON contém a chave 'travelExpenses'
        if (jsonData.containsKey('travelExpenses')) {
          return TravelExpensesInfoModel.fromJson(jsonData);
        } else {
          print('JSON não contém a chave "travelExpenses": $jsonData');
          throw ServerException(
            message: 'Formato de resposta inválido: chave "travelExpenses" não encontrada',
            statusCode: 500,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to load travel expenses: Status code ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      if (e is ServerException) rethrow;
      throw ConnectionException(message: 'No internet connection: $e');
    }
  }
}
