import '../../../../exports.dart';
import 'travel_card_model.dart';

class TravelExpensesInfoModel extends TravelExpensesInfoEntity {
  const TravelExpensesInfoModel({
    required super.despesasdeviagem,
    required super.cartoes,
  });

  factory TravelExpensesInfoModel.fromJson(Map<String, dynamic> json) {
    List<TravelExpenseModel> despesas = [];
    List<TravelCardModel> cartoes = [];

    if (json.containsKey('travelExpenses')) {
      despesas = _convertDespesas(json['travelExpenses']);
    } else if (json.containsKey('despesasdeviagem')) {
      despesas = _convertDespesas(json['despesasdeviagem']);
    }

    if (json.containsKey('cards')) {
      cartoes = _convertCartoes(json['cards']);
    } else if (json.containsKey('cartoes')) {
      cartoes = _convertCartoes(json['cartoes']);
    }

    return TravelExpensesInfoModel(
      despesasdeviagem: despesas,
      cartoes: cartoes,
    );
  }

  static List<TravelExpenseModel> _convertDespesas(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is TravelExpenseModel) {
          return item;
        }
        return TravelExpenseModel.fromJson(item);
      } catch (e) {
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

  static List<TravelCardModel> _convertCartoes(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is TravelCardModel) {
          return item;
        }
        return TravelCardModel.fromJson(item);
      } catch (e) {
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
