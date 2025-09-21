import 'package:flutter/material.dart';

/// Widget reutilizável para seleção de data
/// 
/// Este componente é Stateless e usa callbacks para comunicar mudanças,
/// seguindo o princípio de responsabilidade única
class DatePickerField extends StatelessWidget {
  /// Data atualmente selecionada
  final DateTime? selectedDate;
  
  /// Callback chamado quando uma data é selecionada
  final ValueChanged<DateTime?> onDateSelected;
  
  /// Data mínima selecionável (padrão: hoje)
  final DateTime? firstDate;
  
  /// Data máxima selecionável (padrão: 2100)
  final DateTime? lastDate;
  
  /// Define se o campo é obrigatório
  final bool isRequired;
  
  /// Texto de erro a ser exibido
  final String? errorText;

  /// Construtor do campo de seleção de data
  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.isRequired = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final effectiveFirstDate = firstDate ?? DateTime(today.year, today.month, today.day);
    final effectiveLastDate = lastDate ?? DateTime(2100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequired ? 'Data do Evento *' : 'Data do Evento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showDatePicker(context, effectiveFirstDate, effectiveLastDate),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText != null 
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Selecione a data do evento'
                          : _formatDate(selectedDate!),
                      style: TextStyle(
                        color: selectedDate == null
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// Exibe o seletor de data
  Future<void> _showDatePicker(
    BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    final selectedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (selectedDateTime != null) {
      onDateSelected(selectedDateTime);
    }
  }
  
  /// Formata a data para exibição
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}