import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/model/modelo.dart';

class Anuncio {
  final int? id;
  final Modelo? modelo;
  final Cidade? cidade;
  final String descricao;
  final double valor;
  final int ano;
  final int km;
  final int idCidade;
  final int idModelo;

  Anuncio({
    this.id,
    this.modelo,
    this.cidade,
    required this.descricao,
    required this.valor,
    required this.ano,
    required this.km,
    required this.idCidade,
    required this.idModelo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descricao'] = descricao;
    data['valor'] = valor;
    data['ano'] = ano;
    data['km'] = km;
    data['idCidade'] = idCidade;
    data['idModelo'] = idModelo;
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      id: json['id'],
      modelo: json['modelo'] != null ? Modelo.fromJson(json['modelo']) : null,
      cidade: json['cidade'] != null ? Cidade.fromJson(json['cidade']) : null,
      descricao: json['descricao'],
      valor: (json['valor'] as num).toDouble(),
      ano: json['ano'],
      km: json['km'],
      idCidade: json['idCidade'],
      idModelo: json['idModelo'],
    );
  }
}