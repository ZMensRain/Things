// ignore_for_file: unused_import

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

class LocalNotificationService {
  LocalNotificationService();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@drawable/ic_stat_temp");
    final DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );
    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onInteractedWithNotification);
  }

  void _onDidReceiveLocalNotification(id, title, body, payload) {
    print(id);
  }

  void onInteractedWithNotification(NotificationResponse details) {
    print(details.payload);
  }

  Future<NotificationDetails> getNotificationDetails() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "channelDescription",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();
    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  Future<void> sendNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await getNotificationDetails();
    _localNotificationService.show(id, title, body, details);
  }

  void cancle(int id) async {
    await _localNotificationService.cancel(id);
  }

  Future<void> periodicallySendNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _localNotificationService.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.everyMinute,
      await getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: "aaaaa",
    );
  }
}
