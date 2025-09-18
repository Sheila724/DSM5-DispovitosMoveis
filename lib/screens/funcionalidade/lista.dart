import 'package:flutter/material.dart';
import '../../models/modelo_principal.dart';
import 'formulario.dart';
import '../splash.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  final List<Evento> _eventos = [];

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
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
