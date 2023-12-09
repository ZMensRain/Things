import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Rating {
  Rating(this.time, this.value, {String? id}) : id = id ?? uuid.v4();

  final DateTime time;
  final double value;
  final String id;
}
