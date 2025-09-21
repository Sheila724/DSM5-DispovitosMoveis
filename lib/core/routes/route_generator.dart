import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/event/presentation/pages/event_list_page.dart';
import '../../features/event/presentation/pages/event_form_page.dart';
import '../../features/event/domain/event_model.dart';

/// Gerador de rotas da aplicação
class RouteGenerator {
  /// Gera as rotas baseado no nome da rota
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _createRoute(const SplashPage());
        
      case AppRoutes.eventList:
        return _createRoute(const EventListPage());
        
      case AppRoutes.eventForm:
        return _createRoute(const EventFormPage());
        
      case AppRoutes.eventEdit:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          final event = args['event'] as EventModel?;
          final index = args['index'] as int?;
          if (event != null && index != null) {
            return _createRoute(EventFormPage(event: event, eventIndex: index));
          }
        }
        return _createErrorRoute('Evento não encontrado');
        
      default:
        return _createErrorRoute('Rota não encontrada');
    }
  }
  
  /// Cria uma rota com transição personalizada
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  
  /// Cria uma rota de erro
  static Route<dynamic> _createErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}