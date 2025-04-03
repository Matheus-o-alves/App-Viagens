import 'package:equatable/equatable.dart';


abstract class TravelExpensesInfoEntity extends Equatable {
  final List<dynamic> despesasdeviagem;
  final List<dynamic> cartoes;

  const TravelExpensesInfoEntity({
    required this.despesasdeviagem,
    required this.cartoes,
  });

  @override
  List<Object> get props => [despesasdeviagem, cartoes];
}
