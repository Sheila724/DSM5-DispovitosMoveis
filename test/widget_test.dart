// Testes de widget para o aplicativo Eventos Locais
//
// Estes testes verificam se os componentes principais da aplicação
// funcionam corretamente, incluindo navegação e funcionalidades básicas.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trabalho/main.dart';

void main() {
  group('EventosLocaisApp Tests', () {
    testWidgets('App deve inicializar e mostrar splash screen', (WidgetTester tester) async {
      // Constrói nossa aplicação e dispara um frame
      await tester.pumpWidget(const EventosLocaisApp());

      // Verifica se o app inicializa corretamente
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Aguarda a splash screen aparecer
      await tester.pump();
      
      // Verifica se encontra elementos da splash screen
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App deve ter configurações corretas', (WidgetTester tester) async {
      // Constrói nossa aplicação
      await tester.pumpWidget(const EventosLocaisApp());
      
      // Busca o MaterialApp widget
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      
      // Verifica configurações básicas
      expect(app.title, 'Eventos Locais');
      expect(app.debugShowCheckedModeBanner, false);
      expect(app.locale, const Locale('pt', 'BR'));
    });
  });
}
