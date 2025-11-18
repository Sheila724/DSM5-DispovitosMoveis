// lib/screens/funcionalidade/lista.dart

import 'package:flutter/material.dart';
import '../../database/dao/evento_dao.dart';
import '../../models/modelo_principal.dart';
import 'package:trabalho/services/lib/services/analytics_service.dart';
import 'formulario.dart';
import '../../shared/widgets/app_drawer.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  late Future<List<Evento>> eventosFuture;
  DateTime? _enteredTime;

  @override
  void initState() {
    super.initState();
    _loadEventos();
    AnalyticsService.increment('lista_v1_open');
    _enteredTime = DateTime.now();
  }

  @override
  void dispose() {
    if (_enteredTime != null) {
      AnalyticsService.logTime(
          'time_lista_v1', DateTime.now().difference(_enteredTime!));
    }
    super.dispose();
  }

  void _loadEventos() {
    eventosFuture = EventoDao().listar();
  }

  Future<void> _deleteEvento(int id) async {
    await AnalyticsService.increment('lista_v1_delete');
    await EventoDao().excluir(id);
    _loadEventos();
    setState(() {});
  }

  Future<void> _editarEvento(Evento evento) async {
    await AnalyticsService.increment('lista_v1_edit_click');
    if (!mounted) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => FormularioEvento(evento: evento, source: 'v1')),
    );
    if (result == true) {
      _loadEventos();
      setState(() {});
    }
  }

  Future<void> _novoEvento() async {
    await AnalyticsService.increment('lista_v1_new_click');
    if (!mounted) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioEvento(source: 'v1')),
    );
    if (result == true) {
      _loadEventos();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Eventos (V1)"),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _novoEvento,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Evento>>(
        future: eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado."));
          }

          final eventos = snapshot.data!;

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(evento.nome),
                  subtitle: Text(
                      "${evento.tipo} • ${evento.data.day}/${evento.data.month}/${evento.data.year}"),
                  onTap: () async {
                    await AnalyticsService.increment('lista_v1_item_click');
                    // você pode abrir um detalhe se quiser
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarEvento(evento),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmado = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content:
                                  Text('Excluir o evento "${evento.nome}"?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar')),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Excluir')),
                              ],
                            ),
                          );
                          if (confirmado == true) {
                            await _deleteEvento(evento.id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
