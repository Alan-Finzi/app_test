
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Scheduling_model.dart';
import '../model/cancha_model.dart';

class DatabaseHelper {
    static final DatabaseHelper _instance = DatabaseHelper._internal();

    factory DatabaseHelper() => _instance;

    DatabaseHelper._internal() {
        // Llama a initDatabase desde el constructor y espera su finalización
        initDatabase().then((_) {
            print("Database initialized");
        }).catchError((error) {
            print("Error initializing database: $error");
        });
    }

    late Database _database;

    Future<Database> get database async {
        if (_database == null) {
            await initDatabase(); // Asegura que _database esté inicializado antes de devolverlo
        }
        return _database;
    }

    Future<void> initDatabase() async {
        String path = join(await getDatabasesPath(), 'app_database.db');
        _database = await openDatabase(
            path,
            version: 1,
            onCreate: (Database db, int version) async {
                // crear tabla scheduling
                await db.execute(
                    "CREATE TABLE scheduling(id INTEGER PRIMARY KEY AUTOINCREMENT,cancha_id INTEGER,date TEXT,user TEXT,FOREIGN KEY (cancha_id) REFERENCES cancha(id), UNIQUE(cancha_id, date))",
                );
                // crear tabla cancha
                await db.execute("CREATE TABLE cancha(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
                // Insertar tres canchas pre-cargadas
                await db.insert('cancha', {'name': 'Cancha A'});
                await db.insert('cancha', {'name': 'Cancha B'});
                await db.insert('cancha', {'name': 'Cancha C'});
            },
        );
    }

     Future<void> insertCancha(CanchaModel cancha) async {
        Database db = await database;
        await db.insert(
            'cancha',
            cancha.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<int> insertScheduling(SchedulingModel schedulingModel) async {
        try {
            Database db = await database;
            return await db.insert('scheduling', {
                'cancha_id': schedulingModel.cancha?.id,
                'date': schedulingModel.formattedDate(schedulingModel.date),
                'user': schedulingModel.user,
            });
        } on DatabaseException catch (e) {
            if (e.isUniqueConstraintError()) {
                return -1;
            } else {
                print("Error al insertar en la base de datos: $e");
                rethrow;
            }
        }
    }

     Future<List<CanchaModel>> getCanchas() async {
        final List<Map<String, dynamic>> maps = await _database.query('cancha');
        return List.generate(maps.length, (i) {
            return CanchaModel(
                id: maps[i]['id'],
                name: maps[i]['name'],
            );
        });
    }

    Future<List<SchedulingModel>> getScheduling() async {
        Database db = await database;
        List<Map<String, dynamic>> maps = await db.query('scheduling');
        List<SchedulingModel> schedulingList = [];

        for (var map in maps) {
            // Obtener la información completa de la cancha
            CanchaModel cancha = await getCanchaById(map['cancha_id']);

            schedulingList.add(
                SchedulingModel(
                    id: map['id'],
                    cancha: cancha,
                    date:DateFormat('yyyy-MM-dd').parse(map['date']),
                    user: map['user'],
                ),
            );
        }

        return schedulingList;
    }

    Future<int> deleteScheduling(int id) async {
        Database db = await database;
        return await db.delete('scheduling', where: 'id = ?', whereArgs: [id]);
    }

    Future<CanchaModel> getCanchaById(int? id) async {
        Database db = await database;
        List<Map<String, dynamic>> maps = await db.query('cancha', where: 'id = ?', whereArgs: [id]);
        if (maps.isNotEmpty) {
            return CanchaModel.fromMap(maps.first);
        } else {
            return CanchaModel();
        }
    }

}
