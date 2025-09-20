import 'package:flutter/material.dart';
import '../../models/modelo_principal.dart';
import 'formulario.dart';
import '../splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  List<Evento> _eventos = [];

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final eventosStr = prefs.getString('eventos');
    if (eventosStr != null) {
      setState(() {
        _eventos = Evento.decodeList(eventosStr);
      });
    }
  }

  Future<void> _salvarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eventos', Evento.encodeList(_eventos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Rolê'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Voltar para tela inicial',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _eventos.length,
        itemBuilder: (context, index) {
          final evento = _eventos[index];
          return Card(
            child: ListTile(
              title: Text(evento.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo: ${evento.tipo}'),
                  Text('Data: ${evento.data.day}/${evento.data.month}/${evento.data.year}'),
                  Text(evento.descricao),
                ],
              ),
              leading: const Icon(Icons.event),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    tooltip: 'Editar',
                    onPressed: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormularioEventoEdicao(evento: evento),
                        ),
                      );
                      if (resultado != null && resultado is Evento) {
                        setState(() {
                          _eventos[index] = resultado;
                        });
                        await _salvarEventos();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Excluir',
                    onPressed: () async {
                      setState(() {
                        _eventos.removeAt(index);
                      });
                      await _salvarEventos();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioEvento(),
            ),
          );
          if (resultado != null && resultado is Evento) {
            setState(() {
              _eventos.add(resultado);
            });
            await _salvarEventos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
