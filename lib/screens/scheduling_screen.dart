import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/data_base_helper.dart';
import '../model/Scheduling_model.dart';
import '../model/cancha_model.dart';
import '../services/climate.dart';


class SchedulingScreen extends StatefulWidget {
    @override
    _SchedulingScreenState createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
    final DatabaseHelper _databaseHelper = DatabaseHelper();
    DateTime selectedDate = DateTime.now();
    String selectedCancha = "";
    String userName = "";
   late int selectedCanchaId;
    bool isLoading = false;
    List<CanchaModel> canchas = [];

    @override
    void initState() {
        super.initState();
        loadCanchas();
    }

    Future<void> loadCanchas() async {
        canchas = await _databaseHelper.getCanchas();
        if (canchas.isNotEmpty) {
            setState(() {
                selectedCancha = canchas[0].name!;
                selectedCanchaId = canchas[0].id!;
            });
        }
    }

    Future<void> _selectDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
            locale: const Locale('es', 'ES'), // Configura el idioma a español
            builder: (BuildContext context, Widget? child) {
                return Theme(
                    data: ThemeData.light().copyWith(
                        primaryColor: Colors.green, // Color principal
                        colorScheme: const ColorScheme.light(primary: Colors.green),
                        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                    ),
                    child: child!,
                );
            },
        );

        if (picked != null && picked != selectedDate) {
            setState(() {
                selectedDate = picked;
            });
        }
    }

    Future<void> _showConfirmationDialog() async {
        setState(() {
            isLoading = true;
        });
        double precipitationProbability = await ClimateService().getClimateForDate(selectedDate);
        return showDialog(
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
                                setState(() {
                                    isLoading = false;
                                });
                            },
                            child: Text("Cancelar"),
                        ),
                        TextButton(
                            onPressed: () async {
                                Navigator.of(context).pop();
                                await _addScheduling();
                                setState(() {
                                    isLoading = false;
                                });
                            },
                            child: const Text("Agregar"),
                        ),
                    ],
                );
            },
        );

    }



    Future<void> _addScheduling() async {
        SchedulingModel newScheduling = SchedulingModel(
            cancha: CanchaModel(id: selectedCanchaId),
            date: selectedDate,
            user: userName,
        );

        int result = await _databaseHelper.insertScheduling(newScheduling);

        if (result == -1) {
            // Si result es -1, significa que hubo un error al insertar debido a la restricción única
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Ya hay un agendamiento para esta cancha en esta fecha."),
                        actions: [
                            TextButton(
                                onPressed: () {
                                    Navigator.of(context).pop();
                                },
                                child: const Text("Aceptar"),
                            ),
                        ],
                    );
                },
            );
        }
    }


    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
                Navigator.of(context).pushReplacementNamed("home");
                return true;
            },
          child: Scaffold(
              appBar: AppBar(
                  title: Text('Agregar Agendamiento'),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          if (canchas.isNotEmpty)
                              DropdownButton<int>(
                                  value: selectedCanchaId,
                                  onChanged: (int? newValue) {
                                      setState(() {
                                          selectedCanchaId = newValue!;
                                          selectedCancha = canchas.firstWhere((cancha) => cancha.id == newValue).name!;
                                      });
                                  },
                                  items: canchas.map<DropdownMenuItem<int>>((CanchaModel cancha) {
                                      return DropdownMenuItem<int>(
                                          value: cancha.id,
                                          child: Text(cancha.name!),
                                      );
                                  }).toList(),
                                  hint: const Text('Selecciona la Cancha'),
                              ),
                          const SizedBox(height: 20),
                          Row(
                              children: [
                                  const Text('Fecha del Agendamiento: '),
                                  Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                                  IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () => _selectDate(context),
                                  ),
                              ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Nombre del Usuario',
                              ),
                              onChanged: (value) {
                                  setState(() {
                                      userName = value;
                                  });
                              },
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? CircularProgressIndicator():
                          ElevatedButton(
                              onPressed: () {
                                  _showConfirmationDialog();
                              },
                              child: const Text('Agregar Agendamiento'),
                          ),
                      ],
                  ),
              ),
          ),
        );
    }
}