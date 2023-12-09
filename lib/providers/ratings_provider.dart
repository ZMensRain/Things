import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/main.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class RatingsNotifer extends StateNotifier<List<Rating>> {
  RatingsNotifer(this.thing, this.ref) : super([]);

  final Thing thing;
  final Ref ref;
  void loadRatingsSQL() async {
    var db = await _getDataBase();
    var data = await db.query("'${thing.id}'");

    final convertedData = data.map((row) {
      return Rating(DateTime.fromMillisecondsSinceEpoch(row["dateTime"] as int),
          row["rating"] as double,
          id: row["id"] as String);
    }).toList();

    db.close();
    state = convertedData;
  }

  Future<Database> _getDataBase() async {
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

    return db;
  }

  void addRating(Rating rating) async {
    var database = await _getDataBase();
    await database.insert(
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
    var database = await _getDataBase();
    await database.execute("DELETE FROM '${thing.id}' WHERE id='${rating.id}'");
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
                .toStringAsFixed(2)),
          ),
        );
  }
}

var ratingsProvider =
    StateNotifierProvider.family<RatingsNotifer, List<Rating>, Thing>(
        (ref, thing) => RatingsNotifer(thing, ref));
