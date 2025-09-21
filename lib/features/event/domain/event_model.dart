import 'dart:convert';

/// Modelo de dados para representar um evento
class EventModel {
  /// Nome do evento
  final String nome;
  
  /// Descrição detalhada do evento
  final String descricao;
  
  /// Data e hora do evento
  final DateTime data;
  
  /// Tipo/categoria do evento (cultural, esportivo, educacional, etc.)
  final String tipo;

  /// Construtor do modelo de evento
  const EventModel({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });

  /// Converte o evento para um Map (JSON)
  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'data': data.toIso8601String(),
    'tipo': tipo,
  };

  /// Cria um evento a partir de um Map (JSON)
  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    nome: json['nome'] ?? '',
    descricao: json['descricao'] ?? '',
    data: DateTime.parse(json['data']),
    tipo: json['tipo'] ?? '',
  );

  /// Codifica uma lista de eventos para string JSON
  static String encodeEventList(List<EventModel> eventos) =>
      json.encode(eventos.map((e) => e.toJson()).toList());

  /// Decodifica uma string JSON para lista de eventos
  static List<EventModel> decodeEventList(String eventosStr) {
    if (eventosStr.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(eventosStr);
      return decoded.map<EventModel>((e) => EventModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Cria uma cópia do evento com alguns campos alterados
  EventModel copyWith({
    String? nome,
    String? descricao,
    DateTime? data,
    String? tipo,
  }) {
    return EventModel(
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  String toString() {
    return 'EventModel(nome: $nome, descricao: $descricao, data: $data, tipo: $tipo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.data == data &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
        descricao.hashCode ^
        data.hashCode ^
        tipo.hashCode;
  }
}