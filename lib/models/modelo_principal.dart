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
}
