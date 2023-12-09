import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';

import 'package:rate_a_thing/widgets/ratings_card.dart';

class RatingsList extends StatelessWidget {
  const RatingsList(this.ratings, this.onDismissed, {super.key});
  final List<Rating> ratings;
  final void Function(Rating rating) onDismissed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Dismissible(
          onDismissed: (direction) => onDismissed(ratings[index]),
          key: Key(ratings[index].id),
          child: RatingCard(
            ratings[index],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: ratings.length,
    );
  }
}
