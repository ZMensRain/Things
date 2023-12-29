import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:things/models/thing.dart';
import 'package:things/screens/create_thing_screen.dart';
import 'package:things/screens/thing_detail_screen.dart';
import 'package:things/widgets/things/thing_card.dart';

class ThingsScreen extends StatelessWidget {
  ThingsScreen({super.key});

  final Isar isar = Isar.getInstance()!;

  @override
  Widget build(
    BuildContext context,
  ) {
    Stream<void> t = isar.things.watchLazy();

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
      body: StreamBuilder(
        stream: t,
        builder: (context, snapshot) {
          var things = [];

          isar.txnSync(() {
            things = isar.things.where().findAllSync();
          });
          if (things.isEmpty) {
            return Center(
              child: Text(
                "Nothing here yet...",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: things.length,
            itemBuilder: (context, index) => ThingCard(
              things[index],
              onTaped: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ThingDetailScreen(things[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
