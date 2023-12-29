import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:things/models/rating.dart';
import 'package:things/models/thing.dart';
import 'package:things/widgets/ratings/rate_card.dart';

import 'package:things/helpers/isar_helper.dart' as isar_helper;
import 'package:things/widgets/ratings/ratings_list.dart';

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
    isar_helper.open().then((value) => isar = value);
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
              isar_helper.updateStas(widget.thing);
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

                        isar_helper.updateStas(widget.thing);
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
