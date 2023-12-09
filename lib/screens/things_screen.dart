import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/providers/ratings_provider.dart';
import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:rate_a_thing/screens/create_thing_screen.dart';
import 'package:rate_a_thing/screens/thing_detail_screen.dart';
import 'package:rate_a_thing/widgets/thing_card.dart';

class ThingsScreen extends ConsumerWidget {
  const ThingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final things = ref.watch(thingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Things",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateThingScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: things.isEmpty
          ? Center(
              child: Text(
                "No Things yet...",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: things.length,
              itemBuilder: (context, index) => ThingCard(
                things[index],
                onTaped: () {
                  ref
                      .read(ratingsProvider(things[index]).notifier)
                      .loadRatingsSQL();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ThingDetailScreen(things[index]),
                  ));
                },
              ),
            ),
    );
  }
}
