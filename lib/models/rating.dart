import 'package:isar/isar.dart';

part 'rating.g.dart';

/// An object to store infomation about a rating given to a [Thing]

@collection
class Rating {
  Rating(
    this.time,
    this.value,
    this.thingId,
  );

  final DateTime time;
  final double value;
  Id? id = Isar.autoIncrement;
  final int thingId;
}
