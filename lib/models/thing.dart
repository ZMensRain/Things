import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

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

final List<String> kFrequencies = [
  "Daily",
  "Yearly",
  "Weekly",
  "Monthly",
];

class Thing {
  Thing(
    this.title, {
    this.minRating = 0,
    this.maxRating = 10,
    this.ratingIncrement = 0.1,
    this.notifications = false,
    this.notificationFrequency = "",
    required this.average,
    required this.lastTimeRated,
    required this.color,
    String? id,
  }) : id = id ?? uuid.v4();
  final double maxRating;

  final double minRating;

  final double ratingIncrement;
  final String title;

  final bool notifications;

  final String notificationFrequency;

  final String id;
  final double? average;
  final DateTime? lastTimeRated;
  final Color color;

  Thing copyWith({
    double? maxRating,
    double? minRating,
    double? ratingIncrement,
    String? title,
    bool? notifications,
    String? notificationFrequency,
    String? id,
    double? average,
    DateTime? lastTimeRated,
    Color? color,
  }) {
    return Thing(
      title ?? this.title,
      average: average ?? this.average,
      lastTimeRated: lastTimeRated ?? this.lastTimeRated,
      color: color ?? this.color,
      id: this.id,
      maxRating: maxRating ?? this.maxRating,
      minRating: minRating ?? this.minRating,
      notificationFrequency:
          notificationFrequency ?? this.notificationFrequency,
      notifications: notifications ?? this.notifications,
      ratingIncrement: ratingIncrement ?? this.ratingIncrement,
    );
  }
}

String? titleValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      value.trim().length <= 1 ||
      value.trim().length > 50) {
    return "Must be between 1 and 50 characters.";
  }
  return null;
}
