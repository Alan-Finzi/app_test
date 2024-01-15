import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/data_base_helper.dart';
import '../model/Scheduling_model.dart';
import '../model/cancha_model.dart';
import '../widget/agendar_button.dart'; // Necesario para formatear las fechas


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late final DatabaseHelper _databaseHelper;
  late Future<List<SchedulingModel>> appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    appointmentsFuture = initDatabaseAndRefreshData();
  }

  Future<List<SchedulingModel>> initDatabaseAndRefreshData() async {
    await _databaseHelper.initDatabase();
    return _databaseHelper.getScheduling();
  }

  Future<void> deleteAppointment(int id) async {
    // Lógica para eliminar el agendamiento
    await _databaseHelper.deleteScheduling(id);
    setState(() {
      appointmentsFuture = initDatabaseAndRefreshData();
    });
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este agendamiento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await deleteAppointment(id);
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamientos'),
        backgroundColor: Colors.green, // Color verde asociado al fútbol
      ),
      body: FutureBuilder(
        future: appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar datos'),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text('No hay agendamientos disponibles'),
            );
          } else {
            List<SchedulingModel> appointments = snapshot.data as List<SchedulingModel>;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final formattedDate = DateFormat.yMd().add_jm().format(appointment.date!);

                return ListTile(
                  title: Text('Cancha: ${appointment.cancha?.name ?? 'Desconocido'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: $formattedDate'),
                      Text('Usuario: ${appointment.user ?? 'Desconocido'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.sports_soccer), // Icono de fútbol
                    onPressed: () {
                      _confirmDelete(context, appointment.id!);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: const ButtonSchedule(),
    );
  }
}