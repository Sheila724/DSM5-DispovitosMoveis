import 'package:flutter/material.dart';
import '../../features/event/domain/event_model.dart';

/// Widget reutilizável para exibir um card de evento
///
/// Este componente é Stateless pois apenas exibe informações,
/// não gerencia estado próprio
class EventCard extends StatelessWidget {
  /// Modelo do evento a ser exibido
  final EventModel event;

  /// Callback para edição do evento
  final VoidCallback? onEdit;

  /// Callback para exclusão do evento
  final VoidCallback? onDelete;

  /// Construtor do card de evento
  const EventCard({
    super.key,
    required this.event,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do card com título e ações
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.nome,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                if (onEdit != null || onDelete != null) ...[
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Excluir',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),

            const SizedBox(height: 8),

            // Tipo do evento
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.tipo,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Descrição do evento
            Text(
              event.descricao,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: 12),

            // Data do evento
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(event.data),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formata a data para exibição
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
