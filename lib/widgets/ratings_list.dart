import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';

import 'package:rate_a_thing/widgets/ratings_card.dart';

class RatingsList extends StatelessWidget {
  const RatingsList(this.ratings, this.onDismissed,
      {super.key, required this.controller});
  final List<Rating> ratings;
  final ScrollController controller;
  final void Function(Rating rating) onDismissed;

  @override
  Widget build(BuildContext context) {
    var re = ratings;

    re.sort(
      (a, b) => a.time.compareTo(b.time),
    );
    re = re.reversed.toList();

    return Stack(
      children: [
        ListView.separated(
          controller: controller,
          itemBuilder: (context, index) {
            return Dismissible(
              onDismissed: (direction) => onDismissed(re[index]),
              key: Key(re[index].id),
              child: RatingCard(
                re[index],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: re.length,
        ),
        if (re.isEmpty)
          Center(
            child: Text(
              "No ratings yet...",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
      ],
    );
  }
}
