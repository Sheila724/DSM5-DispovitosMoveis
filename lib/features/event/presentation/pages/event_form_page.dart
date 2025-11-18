import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../shared/widgets/event_type_dropdown.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/services/event_storage_service.dart';
import '../../domain/event_model.dart';

/// Página de formulário para criar/editar eventos
class EventFormPage extends StatefulWidget {
  final EventModel? event;
  final int? eventIndex;

  const EventFormPage({
    super.key,
    this.event,
    this.eventIndex,
  });

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();

  String? _selectedEventType;
  DateTime? _selectedDate;
  String? _dateError;
  bool _isSaving = false;

  final EventStorageService _storageService = EventStorageService.instance;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (_isEditing && widget.event != null) {
      final event = widget.event!;
      _nameController.text = event.nome;
      _descriptionController.text = event.descricao;
      _selectedDate = event.data;

      if (AppConstants.eventTypes.contains(event.tipo)) {
        _selectedEventType = event.tipo;
      } else {
        _selectedEventType = 'Outros';
        _customTypeController.text = event.tipo;
      }
    }
  }

  Future<void> _saveEvent() async {
    FocusScope.of(context).unfocus();

    final dateValidation = _validateDate();
    setState(() {
      _dateError = dateValidation;
    });

    if (!_formKey.currentState!.validate() || dateValidation != null) {
      return;
    }

    try {
      setState(() => _isSaving = true);

      String finalEventType;

      if (_selectedEventType == null || _selectedEventType!.isEmpty) {
        _showErrorSnackBar('Tipo do evento é obrigatório');
        return;
      }

      if (_selectedEventType == 'Outros') {
        final customType = _customTypeController.text.trim();
        if (customType.isEmpty) {
          _showErrorSnackBar('Tipo personalizado é obrigatório');
          return;
        }
        finalEventType = customType;
      } else {
        finalEventType = _selectedEventType!;
      }

      final event = EventModel(
        nome: _nameController.text.trim(),
        descricao: _descriptionController.text.trim(),
        data: _selectedDate!,
        tipo: finalEventType,
      );

      bool success;
      if (_isEditing && widget.eventIndex != null) {
        success = await _storageService.updateEvent(widget.eventIndex!, event);
      } else {
        success = await _storageService.addEvent(event);
      }

      if (success) {
        if (!mounted) return;
        _showSuccessSnackBar(_isEditing
            ? 'Evento atualizado com sucesso!'
            : 'Evento criado com sucesso!');
        Navigator.of(context).pop(true);
      } else {
        if (!mounted) return;
        _showErrorSnackBar('Erro ao salvar evento');
      }
    } catch (e) {
      debugPrint('Erro ao salvar evento: $e');
      _showErrorSnackBar('Erro inesperado ao salvar evento');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateDate() {
    if (_selectedDate == null) {
      return 'Data é obrigatória';
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate =
        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (selectedDate.isBefore(todayDate)) {
      return 'Selecione uma data presente ou futura';
    }
    return null;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Evento' : 'Novo Evento'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: _nameController,
                label: 'Nome do Evento',
                hint: 'Digite o nome do evento',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                isRequired: true,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Descreva o evento',
                maxLines: 3,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                isRequired: true,
              ),
              const SizedBox(height: 12),
              EventTypeDropdown(
                selectedType: _selectedEventType,
                onChanged: (value) {
                  setState(() {
                    _selectedEventType = value;
                    if (value != 'Outros') {
                      _customTypeController.clear();
                    }
                  });
                },
                isRequired: true,
              ),
              if (_selectedEventType == 'Outros') ...[
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _customTypeController,
                  label: 'Tipo Personalizado',
                  hint: 'Digite o tipo específico do evento',
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  isRequired: true,
                  validator: (value) {
                    if (_selectedEventType == 'Outros' &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Tipo personalizado é obrigatório';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              DatePickerField(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    _dateError = null;
                  });
                },
                isRequired: true,
                errorText: _dateError,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Salvando...'),
                          ],
                        )
                      : Text(_isEditing ? 'Atualizar Evento' : 'Criar Evento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
