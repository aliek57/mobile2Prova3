import 'package:mobile2prova3/model/marca.dart';

class Modelo {
  int id = 0;
  String nome = "";
  String tipo = "";
  int idMarca = 0;
  Marca? marca;

  Modelo(
      this.id,
      this.nome,
      this.tipo,
      this.idMarca, {
        this.marca,
      });

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
      json['id'],
      json['nome'],
      json['tipo'],
      json['idMarca'],
      marca: json['marca'] != null ? Marca.fromJson(json['marca']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'idMarca': idMarca,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Modelo &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nome == other.nome &&
              tipo == other.tipo &&
              idMarca == other.idMarca;

  @override
  int get hashCode => Object.hash(id, nome, tipo, idMarca);
}