import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:things/helpers/isar_helper.dart' as isar_helper;
import 'package:things/main.dart';
import 'package:things/models/thing.dart';
import 'package:things/screens/thing_detail_screen.dart';

class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/ic_stat_temp"));
    await _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveNotificationResponse,
    );
  }

  static void send(int thingId, String thingName) {
    _notificationsPlugin.show(
      thingId,
      "Ready to rate $thingName",
      "",
      NotificationDetails(
        android: AndroidNotificationDetails(
          thingId.toString(),
          "rateRemiders",
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: thingId.toString(),
    );
  }

  static Future<NotificationAppLaunchDetails> dets() async {
    initialize();
    return (await _notificationsPlugin.getNotificationAppLaunchDetails())!;
  }
}

void _onDidReceiveNotificationResponse(NotificationResponse details) async {
  var isar = await isar_helper.open();
  var thing = await isar.things
      .filter()
      .idEqualTo(int.parse(details.payload!))
      .findFirst();

  navigatorKey.currentState!.push(
    MaterialPageRoute(
      builder: (context) => ThingDetailScreen(
        thing!,
      ),
    ),
  );
}
