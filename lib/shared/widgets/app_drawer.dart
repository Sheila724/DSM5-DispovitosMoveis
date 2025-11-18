import 'package:flutter/material.dart';
import '../../screens/funcionalidade/lista.dart';
import '../../screens/funcionalidade/status_database_screen.dart';
import '../../screens/funcionalidade/analytics_screen.dart';
import '../../screens/funcionalidade/lista_v2.dart';
import '../../core/theme/theme_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withAlpha((0.12 * 255).round()),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eventos Locais',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha((0.9 * 255).round()),
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          // (Tema escuro) -- movido para o final do Drawer

          // LISTA ORIGINAL
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Lista de Eventos (Original)'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ListaEventos(),
              ));
            },
          ),

          // LISTA V2
          ListTile(
            leading: const Icon(Icons.upgrade),
            title: const Text('Lista de Eventos (V2 - Teste)'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ListaEventosV2(),
              ));
            },
          ),

          const Divider(),

          // STATUS DO BANCO
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Status do Banco'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const StatusDatabaseScreen(),
              ));
            },
          ),

          // ANALYTICS
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Relatório de Métricas'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AnalyticsScreen(),
              ));
            },
          ),
          const Divider(),

          ValueListenableBuilder(
            valueListenable: ThemeController.mode,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return SwitchListTile(
                title: const Text('Tema escuro'),
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                value: isDark,
                onChanged: (v) {
                  ThemeController.setMode(v ? ThemeMode.dark : ThemeMode.light);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
