import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/providers/ratings_provider.dart';
import 'package:rate_a_thing/screens/edit_thing_screen.dart';
import 'package:rate_a_thing/widgets/rate_card.dart';
import 'package:rate_a_thing/widgets/ratings_list.dart';
import 'package:rate_a_thing/widgets/stats/month_card.dart';

class ThingDetailScreen extends ConsumerStatefulWidget {
  const ThingDetailScreen(this.thing, {super.key});
  final Thing thing;
  @override
  ConsumerState<ThingDetailScreen> createState() => _ThingDetailScreenState();
}

class _ThingDetailScreenState extends ConsumerState<ThingDetailScreen> {
  var tab = 0;

  final c = ScrollController();

  void rate(double rating) {
    ref
        .read(ratingsProvider(widget.thing).notifier)
        .addRating(Rating(DateTime.now(), rating));
    c.animateTo(
      0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.ease,
    );
  }

  Map<Months, bool> getMonths(List<Rating> ratings) {
    Map<Months, bool> presnebtMonths = {
      Months.january: false,
      Months.february: false,
      Months.march: false,
      Months.april: false,
      Months.may: false,
      Months.june: false,
      Months.july: false,
      Months.august: false,
      Months.september: false,
      Months.october: false,
      Months.november: false,
      Months.december: false,
    };

    for (var rating in ratings) {
      presnebtMonths[Months.values[rating.time.month - 1]] = true;
    }
    return presnebtMonths;
  }

  @override
  Widget build(BuildContext context) {
    var ratings = ref.watch(ratingsProvider(widget.thing));

    Widget content = Column(
      children: [
        RateCard(
          min: widget.thing.minRating,
          max: widget.thing.maxRating,
          onRate: rate,
        ),
        Expanded(
          child: RatingsList(
            controller: c,
            ratings: ratings,
            onDismissed: (rating) {
              ref
                  .read(ratingsProvider(widget.thing).notifier)
                  .removeRating(rating);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Rating removed"),
                  action: SnackBarAction(
                      label: "undo",
                      onPressed: () {
                        ref
                            .read(ratingsProvider(widget.thing).notifier)
                            .addRating(rating);
                      }),
                ),
              );
            },
          ),
        ),
      ],
    );

    //
    //
    if (tab == 1) {
      var mon = getMonths(ratings);
      mon.removeWhere((key, value) => value == false);
      var a = mon.keys;
      content = Column(children: [
        const SizedBox(height: 10),
        Text(
          "Average by Month",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ...a
            .map(
              (e) => MonthCard(
                month: e.name[0].toUpperCase() + e.name.substring(1),
                numberOfRatings: ref
                    .read(ratingsProvider(widget.thing).notifier)
                    .monthRatings(e),
                average: ref
                        .read(ratingsProvider(widget.thing).notifier)
                        .monthAverage(e) ??
                    0,
              ),
            )
            .toList()
      ]);
      if (a.isEmpty) {
        content = const Center(
          child: Text("Stats only show if you have rated this Thing."),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: widget.thing.color,
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
      body: content,
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
        ],
      ),
    );
  }
}
