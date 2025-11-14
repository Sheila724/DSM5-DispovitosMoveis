class Evento {
  int? id;
  final String nome;
  final String descricao;
  final DateTime data;
  final String tipo;

  Evento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'tipo': tipo,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      data: DateTime.parse(map['data']),
      tipo: map['tipo'],
    );
  }
}
