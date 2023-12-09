import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/providers/ratings_provider.dart';
import 'package:rate_a_thing/screens/edit_thing_screen.dart';
import 'package:rate_a_thing/widgets/ratings_list.dart';

class ThingDetailScreen extends ConsumerStatefulWidget {
  const ThingDetailScreen(this.thing, {super.key});
  final Thing thing;
  @override
  ConsumerState<ThingDetailScreen> createState() => _ThingDetailScreenState();
}

class _ThingDetailScreenState extends ConsumerState<ThingDetailScreen> {
  var tab = 0;
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    var ratings = ref.watch(ratingsProvider(widget.thing));
    Widget content = Column(
      children: [
        const SizedBox(height: 50),
        Text(rating.toString(),
            style: Theme.of(context).textTheme.headlineLarge),
        Slider(
          value: rating,
          onChanged: (value) {
            setState(() {
              rating = double.parse(value.toStringAsFixed(2));
            });
          },
          max: widget.thing.maxRating,
          min: widget.thing.minRating,
          divisions: 100,
          label: rating.toString(),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(ratingsProvider(widget.thing).notifier)
                .addRating(Rating(DateTime.now(), rating));
          },
          icon: const Icon(Icons.star),
          label: const Text("Rate"),
        ),
        const Divider(),
        Expanded(
          child: RatingsList(
            ratings,
            (rating) {
              ref
                  .read(ratingsProvider(widget.thing).notifier)
                  .removeRating(rating);
            },
          ),
        ),
      ],
    );
    if (tab == 1) {
      content = const Column();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.thing.title + (tab == 0 ? "" : " stats"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditThingScreen(widget.thing),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (value) => setState(() {
          tab = value;
        }),
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
