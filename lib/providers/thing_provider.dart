import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class ThingsNotifer extends StateNotifier<List<Thing>> {
  ThingsNotifer() : super([]);

  /// opens the database
  Future<Database> openDatabase() async {
    var dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbpath, "things.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE things(id TEXT PRIMARY KEY,title TEXT, notificationFrequency BIGINT, maxRating REAL,minRating REAL, notifications INTEGER,ratingIncrement REAl, average REAL, lastTimeRated BIGINT, color INTEGER)",
        );
      },
      version: 1,
      readOnly: false,
    );
    return db;
  }

  /// Loads all things from the things table
  Future<void> loadThingsFromSQL() async {
    var db = await openDatabase();
    var data = await db.query("things");
    var d = data.map(
      (row) => Thing(
        row["title"] as String,
        id: row["id"] as String,
        maxRating: row["maxRating"] as double,
        minRating: row["minRating"] as double,
        notifications: row["notifications"] != null
            ? row["notifications"] as int != 0
            : false,
        ratingIncrement: row["ratingIncrement"] as double,
        notificationFrequency: row["notificationFrequency"] as String,
        average: row["average"] as double?,
        lastTimeRated: row["lastTimeRated"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row["lastTimeRated"] as int),
        color: Color(row["color"] as int),
      ),
    );
    state = d.toList();
    db.close();
  }

  /// creates a new table
  void createAThing(Thing newThing) async {
    var db = await openDatabase();

    // Creates the table that will hold the ratings for the new thing
    await db.execute(
        "CREATE TABLE '${newThing.id}'(id TEXT PRIMARY KEY, dateTime BIGINT, rating REAL)");

    // Adds the thing to the things table for easy access
    db.insert(
      "things",
      {
        "id": newThing.id,
        "title": newThing.title,
        "notificationFrequency": newThing.notificationFrequency,
        "maxRating": newThing.maxRating,
        "minRating": newThing.minRating,
        "notifications": newThing.notifications ? 1 : 0,
        "ratingIncrement": newThing.ratingIncrement,
        "color": newThing.color.value,
      },
    );
    db.close();

    // sets the state
    state = [...state, newThing];
  }

  /// + Deletes the table with all ratings for the passed thing,
  /// + removes the passed thing from the state,
  /// + and removes the thing from the things table
  void deleteAThing(Thing thing) async {
    var db = await openDatabase();
    await db.execute("DELETE FROM things WHERE id='${thing.id}'");
    await db.execute("DROP TABLE '${thing.id}'");
    db.close();
    state = state.where((element) => element.id != thing.id).toList();
  }

  void editAThing(Thing old, Thing neu) async {
    var db = await openDatabase();
    await db.execute(
      "UPDATE things SET title='${neu.title}', notificationFrequency='${neu.notificationFrequency}', maxRating= ${neu.maxRating}, minRating=${neu.minRating}, notifications= ${neu.notifications ? 1 : 0},ratingIncrement= ${neu.ratingIncrement}, average=${neu.average}, ${neu.lastTimeRated != null ? "lastTimeRated=${neu.lastTimeRated!.millisecondsSinceEpoch}," : ""} color=${neu.color.value} WHERE id='${old.id}'",
    );
    var i = state.indexWhere((element) => element.id == old.id);
    if (i + 1 == state.length) {
      state = [...state.sublist(0, i), neu];
    } else if (i == 0) {
      state = [neu, ...state.sublist(1)];
    } else {
      state = [...state.sublist(0, i), neu, ...state.sublist(i + 1)];
    }
  }
}

var thingsProvider =
    StateNotifierProvider<ThingsNotifer, List<Thing>>((ref) => ThingsNotifer());
