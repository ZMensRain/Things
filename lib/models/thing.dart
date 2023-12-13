import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

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

// final List<String> kFrequencies = [
//   "Daily",
//   "Yearly",
//   "Weekly",
//   "Monthly",
// ];

class Thing {
  Thing(
    this.title, {
    this.minRating = 0,
    this.maxRating = 10,
    this.notifications = false,
    this.notificationFrequency = KFrequency.daily,
    required this.average,
    required this.lastTimeRated,
    required this.color,
    String? id,
  }) : id = id ?? _uuid.v4();

  Thing copyWith({
    double? maxRating,
    double? minRating,
    double? ratingIncrement,
    String? title,
    bool? notifications,
    KFrequency? notificationFrequency,
    double? average,
    DateTime? lastTimeRated,
    Color? color,
  }) {
    _uuid.v4();
    return Thing(
      title ?? this.title,
      average: average ?? this.average,
      lastTimeRated: lastTimeRated ?? this.lastTimeRated,
      color: color ?? this.color,
      id: id,
      maxRating: maxRating ?? this.maxRating,
      minRating: minRating ?? this.minRating,
      notificationFrequency:
          notificationFrequency ?? this.notificationFrequency,
      notifications: notifications ?? this.notifications,
    );
  }

  Thing.from(Map<String, Object?> row)
      : maxRating = row["maxRating"] as double,
        minRating = row["minRating"] as double,
        average = row["average"] as double?,
        id = row["id"] as String,
        lastTimeRated = row["lastTimeRated"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row["lastTimeRated"] as int),
        color = Color(row["color"] as int),
        title = row["title"] as String,
        notificationFrequency =
            frequencyFromString(row["notificationFrequency"] as String),
        notifications = row["notifications"] != null
            ? row["notifications"] as int != 0
            : false;

  final double maxRating;

  final double minRating;

  final String title;

  final bool notifications;

  final KFrequency notificationFrequency;

  final String id;
  final double? average;
  final DateTime? lastTimeRated;
  final Color color;
}

KFrequency frequencyFromString(String string) {
  switch (string) {
    case "daliy":
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
