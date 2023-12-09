import 'package:flutter/material.dart';

class RateCard extends StatefulWidget {
  const RateCard(
      {super.key, required this.min, required this.max, required this.onRate});
  final double min;
  final double max;
  final void Function(double rating) onRate;
  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(rating.toString(),
            style: Theme.of(context).textTheme.headlineLarge),
        Slider(
          value: rating,
          onChanged: (value) {
            setState(() {
              rating = double.parse(value.toStringAsFixed(2));
            });
          },
          max: widget.max,
          min: widget.min,
          divisions: 100,
          label: rating.toString(),
        ),
        ElevatedButton.icon(
          onPressed: () => widget.onRate(rating),
          icon: const Icon(Icons.star),
          label: const Text("Rate"),
        ),
      ],
    );
  }
}
