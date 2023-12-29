import 'package:rate_a_thing/helpers/notifications.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:workmanager/workmanager.dart';

void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final start = DateTime.now();
    final String frequencyName = inputData!["frequency"];
    KFrequency frequency =
        KFrequency.values.firstWhere((e) => e.name == frequencyName);

    LocalNotificationService.initialize();
    LocalNotificationService.send(
      inputData["thingId"],
      inputData["thingName"],
    );

    registerBackgroundTask(
      start,
      frequency,
      inputData["thingName"],
      inputData["thingId"],
    );

    return true;
  });
}

void registerBackgroundTask(
  DateTime start,
  KFrequency frequency,
  String thingName,
  int thingId,
) {
  Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);

  // Workmanager().registerOneOffTask(
  //   thingId.toString(),
  //   thingId.toString(),
  //   initialDelay: const Duration(minutes: 1),
  //   inputData: {
  //     "thingName": thingName,
  //     "frequency": frequency.name,
  //     "thingId": thingId,
  //   },
  // );
  // return;
  Workmanager().registerOneOffTask(
    thingId.toString(),
    thingId.toString(),
    initialDelay: _getDurationToNext(start, frequency),
    inputData: {
      "thingName": thingName,
      "frequency": frequency.name,
      "thingId": thingId,
    },
  );
}

void cancleTask(int thingId) {
  Workmanager().cancelByUniqueName(thingId.toString());
}

Duration _getDurationToNext(
  DateTime start,
  KFrequency frequency,
) {
  DateTime nextTask = DateTime.now();
  if (start.isBefore(DateTime.now())) {
    late Duration duration;
    switch (frequency) {
      case KFrequency.daily:
        duration = const Duration(days: 1);
        break;
      case KFrequency.weekly:
        duration = const Duration(days: 7);
        break;
      case KFrequency.yearly:
        duration = const Duration(days: 365);
        break;
      case KFrequency.monthly:
        if (start.month == 12) {
          duration =
              start.copyWith(year: start.year + 1, month: 1).difference(start);
        }
        duration = start.copyWith(month: start.month + 1).difference(start);
        break;
      default:
    }
    nextTask = start.add(duration);
    while (nextTask.isBefore(DateTime.now())) {
      nextTask = nextTask.add(duration);
    }
  } else {
    nextTask = start;
  }
  return nextTask.difference(DateTime.now());
}
