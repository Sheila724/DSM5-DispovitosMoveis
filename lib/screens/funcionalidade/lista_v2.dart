// lib/screens/funcionalidade/lista_v2.dart

import 'package:flutter/material.dart';
import '../../database/dao/evento_dao.dart';
import '../../models/modelo_principal.dart';
import 'package:trabalho/services/lib/services/analytics_service.dart';
import 'formulario.dart';
import '../../shared/widgets/app_drawer.dart';

class ListaEventosV2 extends StatefulWidget {
  const ListaEventosV2({super.key});

  @override
  State<ListaEventosV2> createState() => _ListaEventosV2State();
}

class _ListaEventosV2State extends State<ListaEventosV2> {
  late Future<List<Evento>> eventosFuture;
  DateTime? _enteredTime;

  @override
  void initState() {
    super.initState();
    _loadEventos();
    AnalyticsService.increment('lista_v2_open');
    _enteredTime = DateTime.now();
  }

  @override
  void dispose() {
    if (_enteredTime != null) {
      AnalyticsService.logTime(
          'time_lista_v2', DateTime.now().difference(_enteredTime!));
    }
    super.dispose();
  }

  void _loadEventos() {
    eventosFuture = EventoDao().listar();
  }

  Future<void> _deleteEvento(int id) async {
    await AnalyticsService.increment('lista_v2_delete');
    await EventoDao().excluir(id);
    _loadEventos();
    setState(() {});
  }

  Future<void> _editarEvento(Evento evento) async {
    await AnalyticsService.increment('lista_v2_edit_click');
    if (!mounted) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => FormularioEvento(evento: evento, source: 'v2')),
    );
    if (result == true) {
      _loadEventos();
      setState(() {});
    }
  }

  Future<void> _novoEvento() async {
    await AnalyticsService.increment('lista_v2_new_click');
    if (!mounted) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioEvento(source: 'v2')),
    );
    if (result == true) {
      _loadEventos();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Visual alternativo: cards maiores com cor de fundo
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Eventos — Detalhada"),
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
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(evento.nome,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(evento.descricao,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(
                                "${evento.tipo} • ${evento.data.day}/${evento.data.month}/${evento.data.year}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editarEvento(evento)),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEvento(evento.id!)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
