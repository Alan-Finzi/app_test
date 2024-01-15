// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Importa sqflite_ffi para configurar la fábrica de bases de datos

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  testWidgets('Test para showDialog', (WidgetTester tester) async {
    // Variables necesarias para el showDialog
    String userName = 'Usuario';
    DateTime selectedDate = DateTime.now();
    String selectedCancha = 'Cancha A';
    double precipitationProbability = 10.5;

    // Inicializar el widget con el showDialog
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmar Agendamiento"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Usuario: $userName"),
                          Text("Fecha del Agendamiento: ${DateFormat('dd-MM-yyyy').format(selectedDate)}"),
                          Text("Cancha: $selectedCancha"),
                          Text("Probabilidad de Lluvia: ${precipitationProbability.toStringAsFixed(2)}%"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // setState(() {
                            //   isLoading = false;
                            // });
                          },
                          child: Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            // await _addScheduling();
                            // setState(() {
                            //   isLoading = false;
                            // });
                          },
                          child: const Text("Agregar"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Mostrar Dialog'),
            );
          },
        ),
      ),
    );

    // Toca el botón para mostrar el dialog
    await tester.tap(find.text('Mostrar Dialog'));
    await tester.pumpAndSettle();

    // el AlertDialog está presente en la interfaz
    expect(find.byType(AlertDialog), findsOneWidget);


  });
}