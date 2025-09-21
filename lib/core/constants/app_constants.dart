/// Constantes gerais da aplicação
class AppConstants {
  /// Nome da aplicação
  static const String appName = 'Eventos Locais';
  
  /// Versão da aplicação
  static const String appVersion = '1.0.0';
  
  /// Tipos de eventos disponíveis
  static const List<String> eventTypes = [
    'Esportivo',
    'Cultural', 
    'Educacional',
    'Outros'
  ];
  
  /// Chave para armazenamento local de eventos
  static const String eventsStorageKey = 'eventos_salvos';
  
  /// Duração da splash screen
  static const Duration splashDuration = Duration(seconds: 3);
}