import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/event/domain/event_model.dart';
import '../../core/constants/app_constants.dart';

/// Serviço responsável pelo armazenamento local de eventos
/// 
/// Utiliza SharedPreferences para persistir os dados localmente
/// Implementa padrão Repository para abstrair a fonte de dados
class EventStorageService {
  /// Instância única do serviço (Singleton)
  static EventStorageService? _instance;
  
  /// SharedPreferences para armazenamento local
  SharedPreferences? _prefs;

  /// Construtor privado para implementar Singleton
  EventStorageService._();

  /// Getter para obter a instância única do serviço
  static EventStorageService get instance {
    _instance ??= EventStorageService._();
    return _instance!;
  }

  /// Inicializa o SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Salva a lista de eventos no armazenamento local
  /// 
  /// [events] Lista de eventos a ser salva
  /// Retorna [bool] indicando sucesso da operação
  Future<bool> saveEvents(List<EventModel> events) async {
    try {
      await init();
      final eventsJson = EventModel.encodeEventList(events);
      return await _prefs!.setString(AppConstants.eventsStorageKey, eventsJson);
    } catch (e) {
      debugPrint('Erro ao salvar eventos: $e');
      return false;
    }
  }

  /// Carrega a lista de eventos do armazenamento local
  /// 
  /// Retorna [List<EventModel>] lista de eventos ou lista vazia se houver erro
  Future<List<EventModel>> loadEvents() async {
    try {
      await init();
      final eventsJson = _prefs!.getString(AppConstants.eventsStorageKey) ?? '';
      return EventModel.decodeEventList(eventsJson);
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
      return [];
    }
  }

  /// Adiciona um novo evento à lista existente
  /// 
  /// [event] Evento a ser adicionado
  /// Retorna [bool] indicando sucesso da operação
  Future<bool> addEvent(EventModel event) async {
    try {
      final events = await loadEvents();
      events.add(event);
      return await saveEvents(events);
    } catch (e) {
      debugPrint('Erro ao adicionar evento: $e');
      return false;
    }
  }

  /// Atualiza um evento existente na lista
  /// 
  /// [index] Índice do evento a ser atualizado
  /// [updatedEvent] Evento com as informações atualizadas
  /// Retorna [bool] indicando sucesso da operação
  Future<bool> updateEvent(int index, EventModel updatedEvent) async {
    try {
      final events = await loadEvents();
      if (index >= 0 && index < events.length) {
        events[index] = updatedEvent;
        return await saveEvents(events);
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao atualizar evento: $e');
      return false;
    }
  }

  /// Remove um evento da lista
  /// 
  /// [index] Índice do evento a ser removido
  /// Retorna [bool] indicando sucesso da operação
  Future<bool> removeEvent(int index) async {
    try {
      final events = await loadEvents();
      if (index >= 0 && index < events.length) {
        events.removeAt(index);
        return await saveEvents(events);
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao remover evento: $e');
      return false;
    }
  }

  /// Limpa todos os eventos do armazenamento
  /// 
  /// Retorna [bool] indicando sucesso da operação
  Future<bool> clearAllEvents() async {
    try {
      await init();
      return await _prefs!.remove(AppConstants.eventsStorageKey);
    } catch (e) {
      debugPrint('Erro ao limpar eventos: $e');
      return false;
    }
  }
}