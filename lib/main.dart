import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:rate_a_thing/screens/things_screen.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

late Database kDatebase;

void _openDatabase() async {
  var dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, "things.db"),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE things(id TEXT PRIMARY KEY,title TEXT, notificationFrequency BIGINT, maxRating REAL,minRating REAL, notifications INTEGER,ratingIncrement REAl, average REAL, lastTimeRated BIGINT, color INTEGER)",
      );
    },
    version: 1,
    readOnly: false,
  );
  kDatebase = db;
}

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
  _openDatabase();
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ref.read(thingsProvider.notifier).loadThingsFromSQL();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ThingsScreen(),
    );
  }
}
