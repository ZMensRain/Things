import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:rate_a_thing/screens/things_screen.dart';
import 'package:rate_a_thing/services/notification_service.dart';

final service = LocalNotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(thingsProvider.notifier).loadThingsFromSQL();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ThingsScreen(),
    );
  }
}
