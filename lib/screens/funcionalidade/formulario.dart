import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/modelo_principal.dart';

class FormularioEvento extends StatefulWidget {
  const FormularioEvento({super.key});

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  DateTime? _dataSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Evento'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controller: _nomeController,
              label: 'Nome do Evento',
              hint: 'Digite o nome',
              icon: Icons.event,
            ),
            Editor(
              controller: _descricaoController,
              label: 'Descrição',
              hint: 'Digite a descrição',
              icon: Icons.description,
            ),
            Editor(
              controller: _tipoController,
              label: 'Tipo',
              hint: 'Cultural, Esportivo, Educacional...',
              icon: Icons.category,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(_dataSelecionada == null
                        ? 'Selecione a data'
                        : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (data != null) {
                        setState(() {
                          _dataSelecionada = data;
                        });
                      }
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String nome = _nomeController.text;
                final String descricao = _descricaoController.text;
                final String tipo = _tipoController.text;
                final DateTime? data = _dataSelecionada;
                if (nome.isNotEmpty && descricao.isNotEmpty && tipo.isNotEmpty && data != null) {
                  final evento = Evento(
                    nome: nome,
                    descricao: descricao,
                    data: data,
                    tipo: tipo,
                  );
                  Navigator.pop(context, evento);
                }
              },
              child: const Text('Adicionar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
