import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../shared/services/event_storage_service.dart';
import '../../domain/event_model.dart';

/// Página principal que exibe a lista de eventos
/// 
/// Esta página é Stateful pois gerencia o estado da lista de eventos
/// e precisa se atualizar quando eventos são adicionados/editados/removidos
class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  /// Lista de eventos carregados
  List<EventModel> _events = [];
  
  /// Controla o estado de carregamento
  bool _isLoading = true;
  
  /// Serviço de armazenamento de eventos
  final EventStorageService _storageService = EventStorageService.instance;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Carrega os eventos do armazenamento local
  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final events = await _storageService.loadEvents();
      
      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Erro ao carregar eventos');
      }
    }
  }

  /// Navega para a tela de criação de novo evento
  Future<void> _navigateToNewEvent() async {
    final result = await Navigator.of(context).pushNamed(AppRoutes.eventForm);
    
    // Se um evento foi criado, recarrega a lista
    if (result == true) {
      await _loadEvents();
    }
  }

  /// Navega para a tela de edição de evento
  Future<void> _navigateToEditEvent(EventModel event, int index) async {
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.eventEdit,
      arguments: {'event': event, 'index': index},
    );
    
    // Se o evento foi editado, recarrega a lista
    if (result == true) {
      await _loadEvents();
    }
  }

  /// Exibe diálogo de confirmação para excluir evento
  Future<void> _showDeleteConfirmation(EventModel event, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir o evento \"${event.nome}\"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteEvent(index);
    }
  }

  /// Remove um evento da lista
  Future<void> _deleteEvent(int index) async {
    try {
      final success = await _storageService.removeEvent(index);
      
      if (success) {
        await _loadEvents();
        _showSuccessSnackBar('Evento excluído com sucesso!');
      } else {
        _showErrorSnackBar('Erro ao excluir evento');
      }
    } catch (e) {
      debugPrint('Erro ao excluir evento: $e');
      _showErrorSnackBar('Erro ao excluir evento');
    }
  }

  /// Navega de volta para a splash screen
  void _navigateToSplash() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Voltar para tela inicial',
            onPressed: _navigateToSplash,
          ),
        ],
      ),
      
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _events.isEmpty
              ? _buildEmptyState()
              : _buildEventList(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewEvent,
        tooltip: 'Adicionar novo evento',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Constrói o estado vazio (quando não há eventos)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum evento cadastrado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Adicione seu primeiro evento tocando no botão +',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToNewEvent,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Evento'),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a lista de eventos
  Widget _buildEventList() {
    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return EventCard(
            event: event,
            onEdit: () => _navigateToEditEvent(event, index),
            onDelete: () => _showDeleteConfirmation(event, index),
          );
        },
      ),
    );
  }
}