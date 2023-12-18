import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';

class RatingTile extends StatelessWidget {
  const RatingTile(this.rating, {super.key});
  final Rating rating;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        rating.value.toString(),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: Text(
        formatDate(rating.time, [dd, " ", MM, " ", yyyy]),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
      ),
    );
  }
}
