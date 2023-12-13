import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// An object to store infomation about a rating given to a [Thing]
class Rating {
  Rating(
    this.time,
    this.value,
  ) : id = _uuid.v4();

  /// Used to load [Rating]s from the sql database
  Rating.from(Map<String, Object?> data)
      : id = data["id"] as String,
        time = DateTime.fromMillisecondsSinceEpoch(data["dateTime"] as int),
        value = data["rating"] as double;

  final DateTime time;
  final double value;
  final String id;
}
