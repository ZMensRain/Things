import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

enum Months {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

class RatingsNotifer extends StateNotifier<List<Rating>> {
  RatingsNotifer(this.thing, this.ref) : super([]);

  Database? _database;

  final Thing thing;
  final Ref ref;
  void loadRatingsSQL() async {
    if (_database == null || !_database!.isOpen) {
      await _openDatabase();
    }
    var data = await _database!.query("'${thing.id}'");

    state = data
        .map(
          (row) => Rating.from(row),
        )
        .toList();
  }

  Future<void> _openDatabase() async {
    var dbpath = await sql.getDatabasesPath();

    final db = await sql.openDatabase(
      path.join(dbpath, "things.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE '${thing.id}'(id TEXT PRIMARY KEY, dateTime BIGINT, rating REAL)",
        );
      },
      version: 1,
      readOnly: false,
    );

    _database = db;
  }

  void addRating(Rating rating) async {
    if (_database == null || !_database!.isOpen) {
      await _openDatabase();
    }
    await _database!.insert(
      "'${thing.id}'",
      {
        "id": rating.id,
        "dateTime": rating.time.millisecondsSinceEpoch,
        "rating": rating.value,
      },
    );
    state = [...state, rating];
    _updateThingStats();
  }

  void removeRating(Rating rating) async {
    if (_database == null || !_database!.isOpen) {
      await _openDatabase();
    }
    await _database!
        .execute("DELETE FROM '${thing.id}' WHERE id='${rating.id}'");
    state = state.where((r) => r.id != rating.id).toList();
  }

  void _updateThingStats() {
    var lastRated = state.last.time;

    ref.read(thingsProvider.notifier).editAThing(
          thing,
          thing.copyWith(
            lastTimeRated: lastRated,
            average: double.parse((state.fold(
                      0.0,
                      (previousValue, element) => previousValue + element.value,
                    ) /
                    state.length)
                .toStringAsFixed(1)),
          ),
        );
  }

  double? monthAverage(Months month) {
    var items = state.where(
        (element) => element.time.month == Months.values.indexOf(month) + 1);
    if (items.isEmpty) {
      return null;
    }
    var average = items.fold(
            0.0, (previousValue, element) => previousValue + element.value) /
        items.length;
    return average;
  }

  int monthRatings(Months month) {
    return state
        .where(
            (element) => element.time.month == Months.values.indexOf(month) + 1)
        .length;
  }
}

var ratingsProvider =
    StateNotifierProvider.family<RatingsNotifer, List<Rating>, Thing>(
        (ref, thing) => RatingsNotifer(thing, ref));
