import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/constants/app_constants.dart';

/// Função principal da aplicação
/// 
/// Inicializa o aplicativo Flutter com configurações
/// de tema, rotas e outros serviços necessários
void main() {
  runApp(const EventosLocaisApp());
}

/// Widget principal da aplicação
/// 
/// Define configurações globais como tema, rotas e título
class EventosLocaisApp extends StatelessWidget {
  const EventosLocaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configurações básicas
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Tema da aplicação
      theme: AppTheme.lightTheme,
      
      // Configuração de rotas
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      
      // Configuração de localização
      locale: const Locale('pt', 'BR'),
    );
  }
}
