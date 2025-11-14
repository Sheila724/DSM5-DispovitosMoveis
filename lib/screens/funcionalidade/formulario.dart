// lib/screens/funcionalidade/formulario.dart

import 'package:flutter/material.dart';
import '../../database/dao/evento_dao.dart';
import '../../models/modelo_principal.dart';
import '../../services/lib/services/analytics_service.dart';

class FormularioEvento extends StatefulWidget {
  final Evento? evento;
  final String? source; // 'v1' ou 'v2' ou null

  const FormularioEvento({super.key, this.evento, this.source});

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeCtrl;
  late TextEditingController descricaoCtrl;
  String? tipoSelecionado;
  DateTime? dataSelecionada;

  final tipos = [
    "Cultural",
    "Esportivo",
    "Educacional",
    "Religioso",
    "Comunitário",
    "Lazer"
  ];

  bool get isEdit => widget.evento != null;

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.evento?.nome ?? '');
    descricaoCtrl = TextEditingController(text: widget.evento?.descricao ?? '');
    tipoSelecionado = widget.evento?.tipo;
    dataSelecionada = widget.evento?.data;
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (dataSelecionada == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecione uma data')));
      return;
    }
    if (tipoSelecionado == null || tipoSelecionado!.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecione um tipo')));
      return;
    }

    final dao = EventoDao();

    if (isEdit) {
      final updated = Evento(
        id: widget.evento!.id,
        nome: nomeCtrl.text,
        descricao: descricaoCtrl.text,
        tipo: tipoSelecionado!,
        data: dataSelecionada!,
      );

      await dao.atualizar(updated);
      // analytics: editar salvo (por source)
      final src = widget.source ?? 'unknown';
      await AnalyticsService.increment('lista_${src}_edit_save');
      Navigator.pop(context, true);
    } else {
      final novo = Evento(
        nome: nomeCtrl.text,
        descricao: descricaoCtrl.text,
        tipo: tipoSelecionado!,
        data: dataSelecionada!,
      );

      await dao.salvar(novo);
      final src = widget.source ?? 'unknown';
      await AnalyticsService.increment('lista_${src}_new_save');
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Evento' : 'Novo Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome do Evento'),
                validator: (value) =>
                    value!.isEmpty ? 'Digite o nome do evento' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: tipos
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Tipo do Evento'),
                onChanged: (value) => setState(() => tipoSelecionado = value),
                validator: (value) =>
                    value == null ? 'Selecione o tipo do evento' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate: dataSelecionada ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (data != null) setState(() => dataSelecionada = data);
                },
                child: Text(dataSelecionada == null
                    ? 'Selecionar Data'
                    : 'Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoCtrl,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value!.isEmpty ? 'Digite uma descrição' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                child: Text(isEdit ? 'Salvar Alterações' : 'Cadastrar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
