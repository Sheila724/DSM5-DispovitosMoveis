import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../shared/services/event_storage_service.dart';
import '../../domain/event_model.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventModel> _events = [];
  List<EventModel> _filteredEvents = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  bool _sortAscending = true;

  final EventStorageService _storageService = EventStorageService.instance;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() => _isLoading = true);
      final events = await _storageService.loadEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erro ao carregar eventos');
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEvents = _events.where((event) {
        final matchesSearch = event.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.descricao.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesFilter =
            _selectedFilter == 'Todos' || event.tipo.toLowerCase() == _selectedFilter.toLowerCase();

        return matchesSearch && matchesFilter;
      }).toList();

      _filteredEvents.sort((a, b) =>
          _sortAscending ? a.data.compareTo(b.data) : b.data.compareTo(a.data));
    });
  }

  Future<void> _navigateToNewEvent() async {
    final result = await Navigator.of(context).pushNamed(AppRoutes.eventForm);
    if (result == true) await _loadEvents();
  }

  Future<void> _navigateToEditEvent(EventModel event, int index) async {
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.eventEdit,
      arguments: {'event': event, 'index': index},
    );
    if (result == true) await _loadEvents();
  }

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

  void _navigateToSplash() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            tooltip: 'Ordenar por data',
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Voltar para tela inicial',
            onPressed: _navigateToSplash,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildSearchAndFilter(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadEvents,
                        child: ListView.builder(
                          itemCount: _filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = _filteredEvents[index];
                            return Dismissible(
                              key: Key('${event.nome}-$index'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar Exclusão'),
                                        content: Text(
                                            'Deseja realmente excluir o evento "${event.nome}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Theme.of(context).colorScheme.error,
                                            ),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;
                              },
                              onDismissed: (_) => _deleteEvent(index),
                              child: EventCard(
                                event: event,
                                onEdit: () => _navigateToEditEvent(event, index),
                                onDelete: () => _deleteEvent(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewEvent,
        tooltip: 'Adicionar novo evento',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy,
                size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar eventos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                DropdownMenuItem(value: 'Esportivo', child: Text('Esportivo')),
                DropdownMenuItem(value: 'Cultural', child: Text('Cultural')),
                DropdownMenuItem(value: 'Educacional', child: Text('Educacional')),
              ],
              onChanged: (value) {
                _selectedFilter = value ?? 'Todos';
                _applyFilters();
              },
            ),
          ),
        ],
      ),
    );
  }
}
