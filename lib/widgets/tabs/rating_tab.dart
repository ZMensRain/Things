import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/widgets/rate_card.dart';
import 'package:rate_a_thing/widgets/ratings_list.dart';

class RatingTab extends StatefulWidget {
  const RatingTab({
    super.key,
    required this.thing,
    required this.onRate,
    required this.ratings,
  });
  final Thing thing;
  final void Function(double ratng) onRate;
  final List<Rating> ratings;

  @override
  State<RatingTab> createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  final ScrollController scrollController = ScrollController();
  late Isar isar;
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isar = Isar.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RateCard(
          min: widget.thing.minRating,
          max: widget.thing.maxRating,
          onRate: (rating) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.ease,
            );
            widget.onRate(rating);
          },
        ),
        Expanded(
          child: RatingsList(
            controller: scrollController,
            ratings: widget.ratings,
            onDismissed: (rating) async {
              await isar.writeTxn(() => isar.ratings.delete(rating.id!));
              if (context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Rating removed"),
                    action: SnackBarAction(
                      label: "undo",
                      onPressed: () async {
                        rating.id = null;
                        await isar.writeTxn(
                          () => isar.ratings.put(rating),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}