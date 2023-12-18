import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/thing.dart';

class ThingCard extends StatelessWidget {
  const ThingCard(this.thing, {super.key, required this.onTaped});
  final Thing thing;
  final void Function() onTaped;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 5,
      margin: const EdgeInsets.all(6),
      clipBehavior: Clip.hardEdge,
      color: Color(thing.colorValue),
      child: InkWell(
        onTap: onTaped,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thing.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white.withOpacity(0.99)),
                    ),
                    Text(
                      thing.lastTimeRated != null
                          ? formatDate(
                              thing.lastTimeRated!, [dd, " ", MM, " ", yyyy])
                          : "",
                      style: const TextStyle().copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                thing.average != null
                    ? "${thing.average} / ${thing.maxRating}"
                        .replaceAll(".0", "")
                    : "",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white.withOpacity(0.99),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
