import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/screens/things_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open(
    [ThingSchema, RatingSchema],
    directory: dir.path,
  );

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: ThingsScreen(),
    );
  }
}
