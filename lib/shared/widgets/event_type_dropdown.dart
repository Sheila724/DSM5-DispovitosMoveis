import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Widget reutilizável para seleção de tipo de evento
/// 
/// Este componente é Stateless pois recebe o estado via callbacks,
/// seguindo o padrão de elevação de estado (lifting state up)
class EventTypeDropdown extends StatelessWidget {
  /// Tipo atualmente selecionado
  final String? selectedType;
  
  /// Callback chamado quando um tipo é selecionado
  final ValueChanged<String?> onChanged;
  
  /// Define se o campo é obrigatório
  final bool isRequired;

  /// Construtor do dropdown de tipos de evento
  const EventTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequired ? 'Tipo do Evento *' : 'Tipo do Evento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.category),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            hint: const Text('Selecione o tipo do evento'),
            items: AppConstants.eventTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: onChanged,
            validator: isRequired ? _validator : null,
          ),
        ],
      ),
    );
  }
  
  /// Validador para o campo de tipo de evento
  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tipo do evento é obrigatório';
    }
    return null;
  }
}