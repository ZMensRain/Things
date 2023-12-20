import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/screens/edit_thing_screen.dart';
import 'package:rate_a_thing/widgets/tabs/graph.dart';
import 'package:rate_a_thing/widgets/tabs/rating_tab.dart';
import 'package:rate_a_thing/widgets/tabs/stats_tab.dart';

class ThingDetailScreen extends StatefulWidget {
  const ThingDetailScreen(this.thing, {super.key});
  final Thing thing;
  @override
  State<ThingDetailScreen> createState() => _ThingDetailScreenState();
}

class _ThingDetailScreenState extends State<ThingDetailScreen> {
  var tab = 0;

  late Isar isar;
  late Stream<void> ratingsStream;
  void rate(double rating) async {
    await isar.writeTxn(
      () => isar.ratings.put(
        Rating(
          DateTime.now(),
          rating,
          widget.thing.id,
        ),
      ),
    );
    await isar.writeTxn(
      () async {
        final ratings = await isar.ratings
            .filter()
            .thingIdEqualTo(widget.thing.id)
            .findAll();
        final double average = ratings.fold(0.0,
                (previousValue, element) => previousValue + element.value) /
            ratings.length;

        isar.things.put(
          widget.thing.copyWith(
            average: double.parse(average.toStringAsFixed(1)),
            lastTimeRated: DateTime.now(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
    ratingsStream = isar.ratings.watchLazy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(widget.thing.colorValue),
        foregroundColor: Colors.white,
        title: Text(
          widget.thing.title + (tab == 0 ? "" : " stats"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditThingScreen(widget.thing),
                ),
              );
            },
            color: Colors.white,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: ratingsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final List<Rating> ratings = isar.ratings
              .filter()
              .thingIdEqualTo(widget.thing.id)
              .sortByTime()
              .findAllSync();

          if (tab == 0) {
            return RatingTab(
              thing: widget.thing,
              onRate: rate,
              ratings: ratings,
            );
          }
          if (tab == 1) {
            return StatsTab(ratings: ratings);
          }
          if (tab == 2) {
            return GraphTab(thing: widget.thing);
          }
          return const Center(
            child: Text("Something went wrong..."),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (value) => setState(() => tab = value),
        items: const [
          BottomNavigationBarItem(
            label: "Ratings",
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: "Stats",
            icon: Icon(Icons.query_stats),
          ),
          BottomNavigationBarItem(
            label: "Graph",
            icon: Icon(Icons.show_chart_rounded),
          ),
        ],
      ),
    );
  }
}
