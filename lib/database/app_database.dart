import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> getDatabase() async {
  // Se estiver rodando NO ANDROID → usa sqflite normal
  if (Platform.isAndroid || Platform.isIOS) {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'eventos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE eventos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            descricao TEXT,
            data TEXT,
            tipo TEXT
          )
        ''');
      },
    );
  }

  // Se estiver no WINDOWS → usa FFI
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  final dbPath = await databaseFactory.getDatabasesPath();
  final path = join(dbPath, 'eventos.db');

  return await databaseFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE eventos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            descricao TEXT,
            data TEXT,
            tipo TEXT
          )
        ''');
      },
    ),
  );
  
}
