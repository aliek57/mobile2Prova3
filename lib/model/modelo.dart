import 'package:mobile2prova3/model/marca.dart';

class Modelo {
  final int? id;
  final String nome;
  final int idMarca;
  final Marca? marca;
  final String tipo;

  Modelo({
    this.id,
    required this.nome,
    required this.idMarca,
    this.marca,
    required this.tipo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['idMarca'] = idMarca;
    data['tipo'] = tipo;
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
      id: json['id'],
      nome: json['nome'],
      idMarca: json['idMarca'],
      tipo: json['tipo'],
      marca: json['marca'] != null ? Marca.fromJson(json['marca']) : null,
    );
  }
}