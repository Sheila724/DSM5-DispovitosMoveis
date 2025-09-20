import 'dart:convert';

class Evento {
  final String nome;
  final String descricao;
  final DateTime data;
  final String tipo; // cultural, esportivo, educacional

  Evento({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'data': data.toIso8601String(),
    'tipo': tipo,
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    nome: json['nome'],
    descricao: json['descricao'],
    data: DateTime.parse(json['data']),
    tipo: json['tipo'],
  );

  static String encodeList(List<Evento> eventos) =>
      json.encode(eventos.map((e) => e.toJson()).toList());

  static List<Evento> decodeList(String eventosStr) {
    final List<dynamic> decoded = json.decode(eventosStr);
    return decoded.map<Evento>((e) => Evento.fromJson(e)).toList();
  }
}
