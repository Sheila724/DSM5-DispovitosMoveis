import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/modelo_principal.dart';

class FormularioEventoEdicao extends StatefulWidget {
  final Evento evento;
  const FormularioEventoEdicao({super.key, required this.evento});

  @override
  State<FormularioEventoEdicao> createState() => _FormularioEventoEdicaoState();
}

class _FormularioEventoEdicaoState extends State<FormularioEventoEdicao> {
  String? _erroData;
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _tipoController;
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.evento.nome);
    _descricaoController = TextEditingController(text: widget.evento.descricao);
    _tipoController = TextEditingController(text: widget.evento.tipo);
    _dataSelecionada = widget.evento.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Evento'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(_dataSelecionada == null
                            ? 'Selecione a data'
                            : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final hoje = DateTime.now();
                          final data = await showDatePicker(
                            context: context,
                            initialDate: _dataSelecionada ?? hoje,
                            firstDate: DateTime(hoje.year, hoje.month, hoje.day),
                            lastDate: DateTime(2100),
                          );
                          if (data != null) {
                            setState(() {
                              _dataSelecionada = data;
                              _erroData = null;
                            });
                          }
                        },
                        child: const Text('Selecionar Data'),
                      ),
                    ],
                  ),
                  if (_erroData != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _erroData!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
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
                final hoje = DateTime.now();
                if (nome.isNotEmpty && descricao.isNotEmpty && tipo.isNotEmpty && data != null && !data.isBefore(DateTime(hoje.year, hoje.month, hoje.day))) {
                  final evento = Evento(
                    nome: nome,
                    descricao: descricao,
                    data: data,
                    tipo: tipo,
                  );
                  Navigator.pop(context, evento);
                } else if (data != null && data.isBefore(DateTime(hoje.year, hoje.month, hoje.day))) {
                  setState(() {
                    _erroData = 'Selecione uma data presente ou futura.';
                  });
                }
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}

// ...existing code...


class FormularioEvento extends StatefulWidget {
  const FormularioEvento({super.key});

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  String? _erroData;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(_dataSelecionada == null
                            ? 'Selecione a data'
                            : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final hoje = DateTime.now();
                          final data = await showDatePicker(
                            context: context,
                            initialDate: hoje,
                            firstDate: DateTime(hoje.year, hoje.month, hoje.day),
                            lastDate: DateTime(2100),
                          );
                          if (data != null) {
                            setState(() {
                              _dataSelecionada = data;
                              _erroData = null;
                            });
                          }
                        },
                        child: const Text('Selecionar Data'),
                      ),
                    ],
                  ),
                  if (_erroData != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _erroData!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
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
                final hoje = DateTime.now();
                if (nome.isNotEmpty && descricao.isNotEmpty && tipo.isNotEmpty && data != null && !data.isBefore(DateTime(hoje.year, hoje.month, hoje.day))) {
                  final evento = Evento(
                    nome: nome,
                    descricao: descricao,
                    data: data,
                    tipo: tipo,
                  );
                  Navigator.pop(context, evento);
                } else if (data != null && data.isBefore(DateTime(hoje.year, hoje.month, hoje.day))) {
                  setState(() {
                    _erroData = 'Selecione uma data presente ou futura.';
                  });
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
