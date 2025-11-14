// lib/services/analytics_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  /// Incrementa um contador inteiro (ex.: "lista_v1_open")
  static Future<void> increment(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, value + 1);
  }

  /// Soma tempo (em segundos) a uma chave (ex.: "time_lista_v1")
  static Future<void> logTime(String key, Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, total + duration.inSeconds);
  }

  /// Lê todas as métricas (retorna Map<String, Object?>)
  static Future<Map<String, Object?>> getAllMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, Object?> map = {};
    for (final key in prefs.getKeys()) {
      map[key] = prefs.get(key);
    }
    return map;
  }

  /// Zera todas as métricas (útil para testes)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
