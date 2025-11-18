import '../../models/modelo_principal.dart';
import '../app_database.dart';

class EventoDao {
  final String tableName = 'eventos';

  Future<List<Evento>> listar() async {
    final db = await getDatabase();
    final resultado = await db.query(tableName);
    return resultado.map((e) => Evento.fromMap(e)).toList();
  }

  Future<int> salvar(Evento evento) async {
    final db = await getDatabase();
    final map = evento.toMap();
    map.remove('id');
    return await db.insert(tableName, map);
  }

  Future<int> atualizar(Evento evento) async {
    final db = await getDatabase();
    if (evento.id == null) throw Exception('Evento sem ID para atualizar');
    return await db.update(
      tableName,
      evento.toMap(),
      where: 'id = ?',
      whereArgs: [evento.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await getDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
