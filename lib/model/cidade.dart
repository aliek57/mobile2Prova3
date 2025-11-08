class Cidade {
  final int? id;
  final String nome;
  final String ddd;

  Cidade({this.id, required this.nome, required this.ddd});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['ddd'] = ddd;
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      id: json['id'],
      nome: json['nome'],
      ddd: json['ddd'],
    );
  }
}