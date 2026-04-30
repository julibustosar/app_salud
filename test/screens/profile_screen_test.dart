import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_app/presentation/screens/profile.dart';


void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Pruebas de Interfaz (Widget Tests) de ProfileScreen', () {
    
    testWidgets('Debe mostrar el título "Mi Perfil" y los campos de texto', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      
      await tester.pumpAndSettle(); 

      expect(find.text('Mi Perfil'), findsOneWidget);
      expect(find.text('Tu Nombre'), findsWidgets);
    });

    testWidgets('Debe contener el botón de Guardar y el icono de Notificación', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Guardar Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_active), findsOneWidget);
    });

  });
}