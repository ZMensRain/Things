import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';

class RatingCard extends StatelessWidget {
  const RatingCard(this.rating, {super.key});
  final Rating rating;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(rating.value.toString()),
      subtitle: Text(
        formatDate(rating.time, [dd, " ", MM, " ", yyyy]),
        style: const TextStyle().copyWith(color: Colors.white.withOpacity(0.5)),
      ),
    );
  }
}
