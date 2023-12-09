import 'package:flutter/material.dart';

class MonthCard extends StatelessWidget {
  const MonthCard({
    super.key,
    required this.month,
    required this.numberOfRatings,
    required this.average,
  });
  final String month;
  final double average;
  final int numberOfRatings;
  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    numberOfRatings.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
                        ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
            Text(
              average.toStringAsFixed(1).replaceAll(".0", ""),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
