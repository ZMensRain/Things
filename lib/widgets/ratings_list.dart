import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';

import 'package:rate_a_thing/widgets/ratings_card.dart';

/// displays the ratings given to a [Thing]
/// or the message No ratings yet... if there are no [Rating]s
class RatingsList extends StatelessWidget {
  const RatingsList({
    required this.ratings,
    required this.onDismissed,
    required this.controller,
    super.key,
  });

  final List<Rating> ratings;
  final ScrollController controller;
  final void Function(Rating rating) onDismissed;

  @override
  Widget build(BuildContext context) {
    var reversedRatings = ratings;

    reversedRatings.sort((a, b) => a.time.compareTo(b.time));

    reversedRatings = reversedRatings.reversed.toList();

    return Stack(
      children: [
        ListView.separated(
          controller: controller,
          itemBuilder: (context, index) {
            return Dismissible(
              onDismissed: (direction) => onDismissed(reversedRatings[index]),
              key: Key(reversedRatings[index].id.toString()),
              child: RatingCard(
                reversedRatings[index],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: reversedRatings.length,
        ),
        if (reversedRatings.isEmpty)
          Center(
            child: Text(
              "No ratings yet...",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
      ],
    );
  }
}
