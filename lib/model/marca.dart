class Marca {
  final int? id;
  final String nome;

  Marca({this.id, required this.nome});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'],
      nome: json['nome'],
    );
  }
}