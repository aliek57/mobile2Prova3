import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/model/modelo.dart';

class Anuncio {
  int id = 0;
  Modelo? modelo;
  Cidade? cidade;
  String descricao = "";
  double valor = 0.0;
  int ano = 0;
  int km = 0;
  int idCidade = 0;
  int idModelo = 0;

  Anuncio(
      this.id,
      this.descricao,
      this.valor,
      this.ano,
      this.km,
      this.idCidade,
      this.idModelo, {
        this.modelo,
        this.cidade,
      });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      json['id'],
      json['descricao'],
      (json['valor'] as num).toDouble(),
      json['ano'],
      json['km'],
      json['idCidade'],
      json['idModelo'],
      modelo: json['modelo'] != null ? Modelo.fromJson(json['modelo']) : null,
      cidade: json['cidade'] != null ? Cidade.fromJson(json['cidade']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'ano': ano,
      'km': km,
      'idCidade': idCidade,
      'idModelo': idModelo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Anuncio &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              descricao == other.descricao &&
              valor == other.valor &&
              ano == other.ano &&
              km == other.km &&
              idCidade == other.idCidade &&
              idModelo == other.idModelo;

  @override
  int get hashCode => Object.hash(
      id, descricao, valor, ano, km, idCidade, idModelo);
}