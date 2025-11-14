// lib/screens/funcionalidade/status_database_screen.dart

import 'package:flutter/material.dart';
import '../../database/dao/evento_dao.dart';
import '../../models/modelo_principal.dart';
import '../../shared/widgets/app_drawer.dart';

class StatusDatabaseScreen extends StatefulWidget {
  const StatusDatabaseScreen({super.key});

  @override
  State<StatusDatabaseScreen> createState() => _StatusDatabaseScreenState();
}

class _StatusDatabaseScreenState extends State<StatusDatabaseScreen> {
  late Future<List<Evento>> eventosFuture;

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  void _loadEventos() {
    eventosFuture = EventoDao().listar();
  }

  Future<void> _deleteEvento(int id) async {
    await EventoDao().excluir(id);
    _loadEventos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status do Banco de Dados")),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Evento>>(
        future: eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado."));
          } else {
            final eventos = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Nome")),
                  DataColumn(label: Text("Descrição")),
                  DataColumn(label: Text("Tipo")),
                  DataColumn(label: Text("Data")),
                  DataColumn(label: Text("Ações")),
                ],
                rows: eventos.map((e) {
                  return DataRow(cells: [
                    DataCell(Text(e.id.toString())),
                    DataCell(Text(e.nome)),
                    DataCell(Text(e.descricao)),
                    DataCell(Text(e.tipo)),
                    DataCell(
                        Text("${e.data.day}/${e.data.month}/${e.data.year}")),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvento(e.id!),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
