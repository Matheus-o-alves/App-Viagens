
import '../../../../exports.dart';
import 'travel_card_model.dart';


import 'package:flutter/material.dart';

class TravelExpensesInfoModel extends TravelExpensesInfoEntity {
  const TravelExpensesInfoModel({
    required super.despesasdeviagem,
    required super.cartoes,
  });

  factory TravelExpensesInfoModel.fromJson(Map<String, dynamic> json) {
    debugPrint('🔎 Convertendo TravelExpensesInfoModel.fromJson: ${json.keys}');
    
    List<TravelExpenseModel> despesas = [];
    List<TravelCardModel> cartoes = [];

    // Converte despesas
    if (json.containsKey('travelExpenses')) {
      debugPrint('📋 Convertendo despesas de travelExpenses');
      despesas = _convertDespesas(json['travelExpenses']);
    } else if (json.containsKey('despesasdeviagem')) {
      debugPrint('📋 Convertendo despesas de despesasdeviagem');
      despesas = _convertDespesas(json['despesasdeviagem']);
    } else {
      debugPrint('⚠️ Nenhuma chave de despesas encontrada no JSON');
    }

    // Converte cartões
    if (json.containsKey('cards')) {
      debugPrint('💳 Convertendo cartões de cards');
      cartoes = _convertCartoes(json['cards']);
    } else if (json.containsKey('cartoes')) {
      debugPrint('💳 Convertendo cartões de cartoes');
      cartoes = _convertCartoes(json['cartoes']);
    } else {
      debugPrint('⚠️ Nenhuma chave de cartões encontrada no JSON');
    }

    debugPrint('✅ Conversão concluída: ${despesas.length} despesas, ${cartoes.length} cartões');
    return TravelExpensesInfoModel(
      despesasdeviagem: despesas,
      cartoes: cartoes,
    );
  }

  // Método auxiliar para converter lista de despesas
  static List<TravelExpenseModel> _convertDespesas(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is TravelExpenseModel) {
          return item;
        }
        return TravelExpenseModel.fromJson(item);
      } catch (e) {
        debugPrint('❌ Erro ao converter despesa: $e');
        debugPrint('💾 Dados da despesa: $item');
        // Retorna um modelo vazio em caso de erro
        return TravelExpenseModel(
          id: 0,
          expenseDate: DateTime.now(),
          description: 'Erro de conversão',
          categoria: '',
          quantidade: 0,
          reembolsavel: false,
          isReimbursed: false,
          status: 'error',
          paymentMethod: '',
        );
      }
    }).toList();
  }

  // Método auxiliar para converter lista de cartões
  static List<TravelCardModel> _convertCartoes(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is TravelCardModel) {
          return item;
        }
        debugPrint('🔄 Convertendo cartão: $item');
        return TravelCardModel.fromJson(item);
      } catch (e) {
        debugPrint('❌ Erro ao converter cartão: $e');
        debugPrint('💾 Dados do cartão: $item');
        // Retorna um modelo vazio em caso de erro
        return const TravelCardModel(
          id: 0,
          nome: 'Erro de conversão',
          numero: '',
          titular: '',
          validade: '',
          bandeira: '',
          limiteDisponivel: 0,
        );
      }
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final despesas = despesasdeviagem
        .map((e) {
          if (e is TravelExpenseModel) {
            return e.toJson();
          } else {
            return {
              'id': e.id,
              'expenseDate': e.expenseDate.toIso8601String(),
              'description': e.description,
              'categoria': e.categoria,
              'quantidade': e.quantidade,
              'reembolsavel': e.reembolsavel ? 1 : 0,
              'isReimbursed': e.isReimbursed ? 1 : 0,
              'status': e.status,
              'paymentMethod': e.paymentMethod,
            };
          }
        })
        .toList();

    final cards = cartoes
        .map((e) {
          if (e is TravelCardModel) {
            return e.toJson();
          } else {
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
        })
        .toList();

    return {
      'despesasdeviagem': despesas,
      'cartoes': cards,
    };
  }
}