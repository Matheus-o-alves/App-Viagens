import 'package:equatable/equatable.dart';

abstract class TravelCardEntity extends Equatable {
  final int id;
  final String nome;
  final String numero;
  final String titular;
  final String validade;
  final String bandeira;
  final double limiteDisponivel;

  const TravelCardEntity({
    required this.id,
    required this.nome,
    required this.numero,
    required this.titular,
    required this.validade,
    required this.bandeira,
    required this.limiteDisponivel,
  });

  @override
  List<Object?> get props => [
    id,
    nome,
    numero,
    titular,
    validade,
    bandeira,
    limiteDisponivel,
  ];
}