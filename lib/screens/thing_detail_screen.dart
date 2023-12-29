import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:things/models/rating.dart';
import 'package:things/models/thing.dart';

// Tabs
import 'package:things/widgets/tabs/graph.dart';
import 'package:things/widgets/tabs/rating_tab.dart';
import 'package:things/widgets/tabs/stats_tab.dart';

// Screens
import 'package:things/screens/edit_thing_screen.dart';

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

  /// Adds a [Rating] to the current [Thing]
  ///
  /// After adding a [Rating] it updates the stats for the [Thing]
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
        final double average =
            ratings.fold(0.0, (value, rating) => value + rating.value) /
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
              Navigator.push(
                context,
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

          // Returns the selected tab or an error if the tab is not in the options
          switch (tab) {
            case 0:
              return RatingTab(
                thing: widget.thing,
                onRate: rate,
                ratings: ratings,
              );

            case 1:
              return StatsTab(ratings: ratings);

            case 2:
              return GraphTab(thing: widget.thing);

            default:
              return const Center(
                child: Text("Something went wrong..."),
              );
          }
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
