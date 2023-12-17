import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/widgets/stats/month_card.dart';

enum Months {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

class StatsTab extends StatelessWidget {
  const StatsTab({super.key, required this.ratings});
  final List<Rating> ratings;
  Map<Months, bool> getMonths(List<Rating> ratings) {
    Map<Months, bool> presnebtMonths = {
      Months.january: false,
      Months.february: false,
      Months.march: false,
      Months.april: false,
      Months.may: false,
      Months.june: false,
      Months.july: false,
      Months.august: false,
      Months.september: false,
      Months.october: false,
      Months.november: false,
      Months.december: false,
    };

    for (var rating in ratings) {
      presnebtMonths[Months.values[rating.time.month - 1]] = true;
    }
    return presnebtMonths;
  }

  @override
  Widget build(BuildContext context) {
    var mon = getMonths(ratings);
    mon.removeWhere((key, value) => value == false);
    var a = mon.keys;

    return Column(children: [
      const SizedBox(height: 10),
      Text(
        "Average by Month",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      ...a.map((e) {
        // Gets all ratings for this Thing that are in month [e]
        var r = ratings.where(
          (element) => element.time.month == Months.values.indexOf(e) + 1,
        );
        double average = r.fold(0.0,
                (previousValue, element) => previousValue + element.value) /
            r.length;

        return MonthCard(
          month: e.name[0].toUpperCase() + e.name.substring(1),
          numberOfRatings: r.length,
          average: average,
        );
      }).toList()
    ]);
  }
}
