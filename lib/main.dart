import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:things/helpers/isar_helper.dart' as isar_helper;
import 'package:things/helpers/notifications.dart';

import 'package:things/models/rating.dart';
import 'package:things/models/thing.dart';
import 'package:things/screens/thing_detail_screen.dart';
import 'package:things/screens/things_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 0, 255),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 0, 255),
          brightness: Brightness.dark,
          background: const Color.fromARGB(255, 10, 10, 10),
        ),
        useMaterial3: true,
      ),
      home: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  void checkIfNotificationLaunched() async {
    var a = await LocalNotificationService.dets();

    if (a.didNotificationLaunchApp) {
      int id = int.parse(a.notificationResponse!.payload!);
      final isar = await isar_helper.open();
      final thing = await isar.things.filter().idEqualTo(id).findFirst();
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => ThingDetailScreen(
            thing!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    checkIfNotificationLaunched();
    return ThingsScreen();
  }
}
