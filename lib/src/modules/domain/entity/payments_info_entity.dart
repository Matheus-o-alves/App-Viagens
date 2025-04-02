import 'package:equatable/equatable.dart';

import 'payments_schedule_entity.dart';

import 'package:equatable/equatable.dart';

import 'travel_card_entity.dart';

abstract class TravelExpensesInfoEntity extends Equatable {
  final List<TravelExpenseEntity> despesasdeviagem;
  final List<TravelCardEntity> cartoes;

  const TravelExpensesInfoEntity({
    required this.despesasdeviagem,
    required this.cartoes,
  });

  // Método para compatibilidade com código existente
  List<TravelExpenseEntity> get travelExpenses => despesasdeviagem;

  @override
  List<Object?> get props => [despesasdeviagem, cartoes];
}