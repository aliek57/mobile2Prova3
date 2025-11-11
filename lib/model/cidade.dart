class Cidade {
  int id = 0;
  String nome = "";
  String ddd = "";

  Cidade(this.id, this.nome, this.ddd);

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
        json['id'],
        json['nome'],
        json['ddd']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['ddd'] = ddd;

    if (id != 0) {
      data['id'] = id;
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Cidade &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nome == other.nome &&
              ddd == other.ddd;

  @override
  int get hashCode => Object.hash(id, nome, ddd);
}