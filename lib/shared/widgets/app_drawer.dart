import 'package:flutter/material.dart';
import '../../screens/funcionalidade/lista.dart';
import '../../screens/funcionalidade/status_database_screen.dart';
import '../../screens/funcionalidade/analytics_screen.dart';
import '../../screens/funcionalidade/lista_v2.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),

          // LISTA ORIGINAL
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Lista de Eventos (Original)'),
            onTap: () {
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AnalyticsScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
