import '../../../domain/entity/travel_card_entity.dart';

class TravelCardModel extends TravelCardEntity {
  const TravelCardModel({
    required super.id,
    required super.nome,
    required super.numero,
    required super.titular,
    required super.validade,
    required super.bandeira,
    required super.limiteDisponivel,
  });

factory TravelCardModel.fromJson(Map<String, dynamic> json) {
  return TravelCardModel(
    id: json['id'] ?? json['ID'] ?? 0,
    nome: json['name'] ?? json['nome'] ?? json['Name'] ?? '',
    numero: json['number'] ?? json['numero'] ?? json['Number'] ?? '',
    titular: json['holder'] ?? json['titular'] ?? json['Holder'] ?? '',
    validade: json['validThru'] ?? json['validade'] ?? json['ValidThru'] ?? '',
    bandeira: json['brand'] ?? json['bandeira'] ?? json['Brand'] ?? '',
    limiteDisponivel: (json['availableLimit'] ?? json['limiteDisponivel'] ?? json['AvailableLimit'] ?? 0.0).toDouble(),
  );
}
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'nome': nome,         
    'numero': numero,     
    'titular': titular,   
    'validade': validade, 
    'bandeira': bandeira,
    'limiteDisponivel': limiteDisponivel, 
  };
}
  TravelCardModel copyWith({
    int? id,
    String? nome,
    String? numero,
    String? titular,
    String? validade,
    String? bandeira,
    double? limiteDisponivel,
  }) {
    return TravelCardModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numero: numero ?? this.numero,
      titular: titular ?? this.titular,
      validade: validade ?? this.validade,
      bandeira: bandeira ?? this.bandeira,
      limiteDisponivel: limiteDisponivel ?? this.limiteDisponivel,
    );
  }
}