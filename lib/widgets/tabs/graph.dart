import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphTab extends StatefulWidget {
  const GraphTab({super.key});

  @override
  State<GraphTab> createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  final _selectedButtons = [false, true, false];
  bool _canMoveLeft = false;
  bool _canMoveRight = true;

  var date = DateTime.now();

  void updateCanMove() {
    setState(() {
      _canMoveLeft = !_canMoveLeft;
      _canMoveRight = !_canMoveRight;
    });
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
          formatDate(
            date,
            _getDateFormats(),
          ),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: BarChart(
              BarChartData(),
            ),
          ),
        ),
        ToggleButtons(
          renderBorder: false,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < _selectedButtons.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  _selectedButtons[buttonIndex] = true;
                } else {
                  _selectedButtons[buttonIndex] = false;
                }
              }
            });
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
                      updateCanMove();
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
                      updateCanMove();
                    }
                  : null,
              icon: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 48,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
