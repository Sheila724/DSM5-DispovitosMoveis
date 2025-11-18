import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/services/event_storage_service.dart';

/// Página de splash screen da aplicação
///
/// Esta página é mostrada ao inicializar o app e redireciona
/// automaticamente para a lista de eventos após o carregamento
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  /// Controla se está carregando
  bool _isLoading = true;

  /// Controlador de animação para efeitos visuais
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  /// Inicializa as animações da splash screen
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  /// Inicializa os serviços da aplicação
  Future<void> _initializeApp() async {
    try {
      // Inicializa o serviço de armazenamento
      await EventStorageService.instance.init();

      // Aguarda o tempo mínimo da splash screen
      await Future.delayed(AppConstants.splashDuration);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao inicializar app: $e');
      // Mesmo com erro, continua para a próxima tela
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navega para a tela de lista de eventos
  void _navigateToEventList() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.eventList);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo da aplicação
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.2 * 255).round()),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'img/logotipo.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback se a imagem não carregar
                            return Icon(
                              Icons.event,
                              size: 60,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nome da aplicação
                    Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                    ),

                    const SizedBox(height: 8),

                    // Versão da aplicação
                    Text(
                      'v${AppConstants.appVersion}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withAlpha((0.8 * 255).round()),
                          ),
                    ),

                    const SizedBox(height: 48),

                    // Indicador de carregamento ou botão de continuar
                    _isLoading
                        ? Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Carregando...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withAlpha((0.8 * 255).round()),
                                    ),
                              ),
                            ],
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: _navigateToEventList,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Ver Eventos'),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
