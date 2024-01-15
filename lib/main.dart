import 'package:agenda_canchas/model/cancha_model.dart';
import 'package:agenda_canchas/routes/routes.dart';
import 'package:agenda_canchas/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'data/data_base_helper.dart';
import 'model/Scheduling_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    final DatabaseHelper _databaseHelper = DatabaseHelper();

    @override
    void initState() {
        initDatabaseAndRefreshData();
        super.initState();
    }

    //iniciamos BD
    Future<void> initDatabaseAndRefreshData() async {
        await _databaseHelper.initDatabase();
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: const [
                Locale('en'),
            ],
            theme: ThemeData(
                colorScheme: ThemeData().colorScheme.copyWith(
                    primary: AppTheme.accentDarkGreen,
                ),
                focusColor: AppTheme.success,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: AppTheme.success,
                highlightColor: AppTheme.success,
            ),
            debugShowCheckedModeBanner: false,
            //home: MyHomePage(),
            navigatorObservers: [HeroController()],
            initialRoute: "home",
          onGenerateRoute: onGeneratedRoutes,
        );
    }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
     List<CanchaModel> canchas = [];
     List<SchedulingModel> scheduling = [];
    final DatabaseHelper _databaseHelper = DatabaseHelper();

    @override
    void initState() {
        initDatabaseAndRefreshData();
        super.initState();
    }

     Future<void> initDatabaseAndRefreshData() async {
         await _databaseHelper.initDatabase();
         refreshData();
     }

    Future<void> refreshData() async {
        canchas = await _databaseHelper.getCanchas();
        scheduling = await _databaseHelper.getScheduling();
        setState(() {});
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Flutter SQLite Demo'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text(
                            'Canchas:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (canchas.isEmpty)
                            const Text('No hay canchas disponibles')
                        else
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: canchas.length,
                                itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text('Name: ${canchas[index].name}'),
                                    );
                                },
                            ),
                        const SizedBox(height: 20),
                        const Text(
                            'Scheduling:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (scheduling.isEmpty)
                            const Text('No hay programaciones disponibles')
                        else
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: scheduling.length,
                                itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text('User: ${scheduling[index].user}'),
                                        subtitle: Text('Date: ${DateFormat.yMd().add_jm().format(scheduling[index].date!)}'),
                                    );
                                },
                            ),
                    ],
                ),
            ),
        );
    }
}