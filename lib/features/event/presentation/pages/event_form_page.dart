import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../shared/widgets/event_type_dropdown.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/services/event_storage_service.dart';
import '../../domain/event_model.dart';

/// Página de formulário para criar/editar eventos
/// 
/// Esta página é Stateful pois gerencia o estado do formulário
/// e validações dos campos de entrada
class EventFormPage extends StatefulWidget {
  /// Evento a ser editado (null para criação de novo evento)
  final EventModel? event;
  
  /// Índice do evento na lista (usado para edição)
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
  /// Chave global para validação do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  /// Controladores dos campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();
  
  /// Estados do formulário
  String? _selectedEventType;
  DateTime? _selectedDate;
  String? _customEventType;
  String? _dateError;
  
  /// Controla o estado de salvamento
  bool _isSaving = false;
  
  /// Serviço de armazenamento
  final EventStorageService _storageService = EventStorageService.instance;

  /// Indica se está no modo de edição
  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  /// Inicializa o formulário com dados do evento (se editando)
  void _initializeForm() {
    if (_isEditing && widget.event != null) {
      final event = widget.event!;
      _nameController.text = event.nome;
      _descriptionController.text = event.descricao;
      _selectedDate = event.data;
      
      // Verifica se o tipo está na lista padrão
      if (AppConstants.eventTypes.contains(event.tipo)) {
        _selectedEventType = event.tipo;
      } else {
        _selectedEventType = 'Outros';
        _customEventType = event.tipo;
        _customTypeController.text = event.tipo;
      }
    }
  }

  /// Valida e salva o formulário
  Future<void> _saveEvent() async {
    // Remove foco dos campos para validar
    FocusScope.of(context).unfocus();
    
    // Valida data
    final dateValidation = _validateDate();
    setState(() {
      _dateError = dateValidation;
    });
    
    // Valida formulário
    if (!_formKey.currentState!.validate() || dateValidation != null) {
      return;
    }
    
    try {
      setState(() {
        _isSaving = true;
      });
      
      // Determina o tipo final do evento
      final finalEventType = _selectedEventType == 'Outros'
          ? (_customEventType?.trim() ?? '')
          : (_selectedEventType ?? '');
      
      if (finalEventType.isEmpty) {
        _showErrorSnackBar('Tipo do evento é obrigatório');
        return;
      }
      
      // Cria o evento
      final event = EventModel(
        nome: _nameController.text.trim(),
        descricao: _descriptionController.text.trim(),
        data: _selectedDate!,
        tipo: finalEventType,
      );
      
      bool success;
      
      if (_isEditing && widget.eventIndex != null) {
        // Atualiza evento existente
        success = await _storageService.updateEvent(widget.eventIndex!, event);
      } else {
        // Adiciona novo evento
        success = await _storageService.addEvent(event);
      }
      
      if (success) {
        _showSuccessSnackBar(
          _isEditing ? 'Evento atualizado com sucesso!' : 'Evento criado com sucesso!'
        );
        
        // Retorna true para indicar que o evento foi salvo
        Navigator.of(context).pop(true);
      } else {
        _showErrorSnackBar('Erro ao salvar evento');
      }
      
    } catch (e) {
      debugPrint('Erro ao salvar evento: $e');
      _showErrorSnackBar('Erro inesperado ao salvar evento');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// Valida a data selecionada
  String? _validateDate() {
    if (_selectedDate == null) {
      return 'Data é obrigatória';
    }
    
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );
    
    if (selectedDate.isBefore(todayDate)) {
      return 'Selecione uma data presente ou futura';
    }
    
    return null;
  }

  /// Exibe snackbar de sucesso
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Exibe snackbar de erro
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
              // Campo nome do evento
              CustomTextFormField(
                controller: _nameController,
                label: 'Nome do Evento',
                hint: 'Digite o nome do evento',
                icon: Icons.event,
                isRequired: true,
              ),
              
              // Campo descrição
              CustomTextFormField(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Descreva o evento',
                icon: Icons.description,
                maxLines: 3,
                isRequired: true,
              ),
              
              // Dropdown tipo de evento
              EventTypeDropdown(
                selectedType: _selectedEventType,
                onChanged: (value) {
                  setState(() {
                    _selectedEventType = value;
                    if (value != 'Outros') {
                      _customEventType = null;
                      _customTypeController.clear();
                    }
                  });
                },
                isRequired: true,
              ),
              
              // Campo tipo personalizado (só aparece se selecionou 'Outros')
              if (_selectedEventType == 'Outros') ...[
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _customTypeController,
                  label: 'Tipo Personalizado',
                  hint: 'Digite o tipo específico do evento',
                  icon: Icons.edit,
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
              
              // Campo seleção de data
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
              
              // Botão salvar
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