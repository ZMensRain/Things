import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:things/helpers/isar_helper.dart' as isar_helper;
import 'package:things/models/rating.dart';
import 'package:things/models/thing.dart';

class GraphTab extends StatefulWidget {
  const GraphTab({super.key, required this.thing});
  final Thing thing;
  @override
  State<GraphTab> createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  final _selectedButtons = [false, true, false];
  bool _canMoveLeft = false;
  bool _canMoveRight = true;

  var date = DateTime.now();
  late DateTime? earlistDate;
  late DateTime? latestDate;

  late Isar isar;

  List<FlSpot> data = [];

  @override
  void initState() {
    super.initState();
    isar_helper.open().then(
      (value) {
        isar = value;
        latestDate = isar.ratings
            .filter()
            .thingIdEqualTo(widget.thing.id)
            .sortByTimeDesc()
            .findFirstSync()
            ?.time;
        earlistDate = isar.ratings
            .filter()
            .thingIdEqualTo(widget.thing.id)
            .sortByTime()
            .findFirstSync()
            ?.time;
        // sets up the graph data and buttons
        _getGraphData();
        _updateCanMove();
      },
    );
  }

  void _updateCanMove() {
    if (_selectedButtons[0]) {
      setState(() {
        if (earlistDate == null || latestDate == null) {
          _canMoveLeft = false;
          _canMoveRight = false;
        }
        final earlistWeek =
            earlistDate!.add(-Duration(days: earlistDate!.weekday - 1));
        final latestWeek =
            latestDate!.add(-Duration(days: latestDate!.weekday - 1));
        _canMoveLeft =
            !(date.year == earlistWeek.year && date.day == earlistWeek.day);
        _canMoveRight =
            !(date.year == latestWeek.year && date.day == latestWeek.day);
      });
    }
    if (_selectedButtons[1]) {
      setState(
        () {
          _canMoveLeft = !(date.year == earlistDate?.year &&
              date.month == earlistDate?.month);
          _canMoveRight = !(date.year == latestDate?.year &&
              date.month == latestDate?.month);
        },
      );
    }
    if (_selectedButtons[2]) {
      setState(
        () {
          _canMoveLeft = !(date.year == earlistDate?.year);
          _canMoveRight = !(date.year == latestDate?.year);
        },
      );
    }
  }

  void _moveView(bool left) {
    if (_selectedButtons[0]) {
      if (left) {
        date = date.add(-const Duration(days: 7));
      } else {
        date = date.add(const Duration(days: 7));
      }
    }
    if (_selectedButtons[1]) {
      if (left) {
        if (date.month == 1) {
          date = date.copyWith(year: date.year - 1, month: 12);
        } else {
          date = date.copyWith(month: date.month - 1);
        }
      } else {
        if (date.month == 12) {
          date = date.copyWith(year: date.year + 1, month: 1);
        } else {
          date = date.copyWith(month: date.month + 1);
        }
      }
    }
    if (_selectedButtons[2]) {
      if (left) {
        date = date.copyWith(year: date.year - 1);
      } else {
        date = date.copyWith(year: date.year + 1);
      }
    }
    _getGraphData();
    _updateCanMove();
  }

  void _getGraphData() async {
    List<FlSpot> points = [];
    if (_selectedButtons[0]) {
      date = date.add(-Duration(days: date.weekday - 1));
      final weekRatings = await isar.ratings
          .filter()
          .thingIdEqualTo(widget.thing.id)
          .timeBetween(
            date,
            date.add(
              const Duration(days: 7),
            ),
          )
          .findAll();

      for (var i = 1; i <= 7; i++) {
        var dayRatings =
            weekRatings.where((element) => element.time.weekday == i);
        if (dayRatings.isEmpty) {
          points.add(FlSpot(i - 1, 0));
        } else {
          points.add(
            FlSpot(
              i - 1,
              dayRatings.fold(0.0, (pv, rating) => pv + rating.value) /
                  dayRatings.length,
            ),
          );
        }
      }
    }
    if (_selectedButtons[1]) {
      // Gets all ratings for the current month
      final monthRatings = await isar.ratings
          .filter()
          .thingIdEqualTo(widget.thing.id)
          .timeBetween(
            date.copyWith(day: 1).add(-const Duration(days: 1)),
            date.copyWith(month: date.month + 1, day: 1),
          )
          .findAll();

      // Creates all the points for the fetched data
      for (var i = 1; i <= 31; i++) {
        // sorts ratings for the day of the month
        var dayRatings = monthRatings.where((element) => element.time.day == i);
        // Check if there are ratings for the day and
        // calculates the average rating on that day for the y of the point
        if (dayRatings.isNotEmpty) {
          points.add(
            FlSpot(
              i - 1,
              dayRatings.fold(0.0, (pv, rating) => pv + rating.value) /
                  dayRatings.length,
            ),
          );
        } else {
          points.add(FlSpot(i - 1, 0));
        }
      }
    }
    if (_selectedButtons[2]) {
      var yearRatings = await isar.ratings
          .filter()
          .thingIdEqualTo(widget.thing.id)
          .timeBetween(
            DateTime(date.year),
            DateTime(date.year + 1).add(-const Duration(days: 1)),
          )
          .findAll();

      for (var i = 1; i <= 12; i++) {
        var monthRatings =
            yearRatings.where((element) => element.time.month == i);
        if (monthRatings.isEmpty) {
          points.add(FlSpot(i - 1, 0));
        } else {
          var average = monthRatings.fold(0.0,
                  (previousValue, element) => previousValue + element.value) /
              monthRatings.length;
          points.add(FlSpot(i - 1, average));
        }
      }
    }

    setState(() => data = points);
  }

  List<String> _getDateFormats() {
    if (_selectedButtons[0]) {
      return [dd, " ", M, " ", yyyy];
    }
    if (_selectedButtons[1]) {
      return [M, " ", yyyy];
    }
    if (_selectedButtons[2]) {
      return [yyyy];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          formatDate(date, _getDateFormats()),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: LineChart(
            LineChartData(
              maxY: widget.thing.maxRating,
              minY: widget.thing.minRating,
              lineBarsData: [
                LineChartBarData(
                  dotData: const FlDotData(
                    show: false,
                  ),
                  barWidth: 2.5,
                  color: Theme.of(context).colorScheme.primary,
                  spots: data,
                ),
              ],
            ),
          ),
        ),
        ToggleButtons(
          renderBorder: false,
          onPressed: (int index) {
            setState(
              () {
                for (int buttonIndex = 0;
                    buttonIndex < _selectedButtons.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _selectedButtons[buttonIndex] = true;
                  } else {
                    _selectedButtons[buttonIndex] = false;
                  }
                }
                _getGraphData();
                _updateCanMove();
              },
            );
          },
          isSelected: _selectedButtons,
          children: const [
            Text("Week"),
            Text("Month"),
            Text("Year"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _canMoveLeft
                  ? () {
                      _moveView(true);
                    }
                  : null,
              icon: const Icon(
                Icons.arrow_circle_left_outlined,
                size: 48,
              ),
            ),
            const SizedBox(width: 48),
            IconButton(
              onPressed: _canMoveRight
                  ? () {
                      _moveView(false);
                    }
                  : null,
              icon: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 48,
              ),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     var dateA = DateTime(2023, 1, 1);
        //     var i = 1;
        //     Random random = Random();
        //     while (i != 365 * 8) {
        //       var value = random.nextInt(10);
        //       await isar.writeTxn(
        //         () => isar.ratings.put(
        //           Rating(dateA, value.toDouble(), 1),
        //         ),
        //       );
        //       dateA = dateA.add(
        //         const Duration(days: 1),
        //       );
        //       i += 1;
        //     }
        //   },
        //   child: const Text("Generate"),
        // ),
      ],
    );
  }
}
