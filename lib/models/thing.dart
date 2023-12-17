import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'thing.g.dart';

final List<Color> kColors = [
  Colors.red,
  Colors.lightGreen,
  Colors.blue,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.amber,
  Colors.indigo,
  Colors.pink,
];

enum KFrequency {
  daily,
  yearly,
  weekly,
  monthly,
}

@collection
class Thing {
  Thing(
    this.title, {
    this.minRating = 0,
    this.maxRating = 10,
    this.notifications = false,
    this.notificationFrequency = KFrequency.daily,
    required this.average,
    required this.lastTimeRated,
    required this.colorValue,
  });

  Id id = Isar.autoIncrement;
  final double maxRating;
  final double minRating;

  final String title;

  final double? average;
  final DateTime? lastTimeRated;
  final int colorValue;

  final bool notifications;

  @enumerated
  final KFrequency notificationFrequency;

  Thing copyWith({
    String? title,
    double? average,
    DateTime? lastTimeRated,
    int? colorValue,
    bool? notifications,
    KFrequency? notificationFrequency,
  }) {
    var thing = Thing(
      title ?? this.title,
      average: average ?? this.average,
      lastTimeRated: lastTimeRated ?? this.lastTimeRated,
      colorValue: colorValue ?? this.colorValue,
    );
    thing.id = id;
    return thing;
  }
}

@Deprecated("Moving to isar")
KFrequency frequencyFromString(String string) {
  switch (string) {
    case "daily":
      return KFrequency.daily;
    case "yearly":
      return KFrequency.yearly;
    case "weekly":
      return KFrequency.weekly;
    case "monthly":
      return KFrequency.monthly;
    default:
      return KFrequency.daily;
  }
}

String? titleValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      value.trim().length <= 1 ||
      value.trim().length > 26) {
    return "Must be between 1 and 50 characters.";
  }
  return null;
}
