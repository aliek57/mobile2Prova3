class Marca {
  int id = 0;
  String nome = "";

  Marca(this.id, this.nome);

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
        json['id'],
        json['nome']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;

    if (id != 0) {
      data['id'] = id;
    }

    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Marca &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nome == other.nome;

  @override
  int get hashCode => Object.hash(id, nome);
}