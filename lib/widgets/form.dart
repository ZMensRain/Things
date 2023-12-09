import 'package:flutter/material.dart';
import 'package:rate_a_thing/models/thing.dart';

class ThingForm extends StatefulWidget {
  const ThingForm({super.key});

  @override
  State<ThingForm> createState() => _ThingFormState();
}

class _ThingFormState extends State<ThingForm> {
  Color _selectedColor = Colors.red;

  KFrequency _selectedFrequency = KFrequency.daily;

  String _enteredTitle = '';

  bool _sendNotifications = false;

  double _minRating = 0;

  double _maxRating = 10;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Title field
          TextFormField(
            initialValue: _enteredTitle,
            decoration: const InputDecoration(
              label: Text("Title"),
              hintText: "Leg Day",
            ),
            validator: titleValidator,
            onSaved: (newValue) {
              _enteredTitle =
                  newValue![0].toUpperCase() + newValue.substring(1);
            },
          ),
          const SizedBox(height: 16),

          // Color selector
          Expanded(
            child: DropdownButtonFormField<Color>(
              value: _selectedColor,
              items: kColors
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Container(
                        color: c,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
          ),

          // Min and max fields
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return "A number has to be entred";
                      }
                      if (double.parse(value) < 0) {
                        return "Number must be >= 0";
                      }
                      if (double.parse(value) > 100000) {
                        return "number can't be bigger than 100,000";
                      }
                      if (double.parse(value) > _maxRating) {
                        return "The min rating must be lower than the max";
                      }
                      return null;
                    },
                    initialValue: "0",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration().copyWith(
                      hintText: "0",
                      label: const Text("Min Rating"),
                    ),
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        return;
                      }

                      _minRating = double.parse(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return "A number has to be entred";
                      }
                      if (double.parse(value) < 0) {
                        return "Number must be >= 0";
                      }
                      if (double.parse(value) > 100000) {
                        return "number can't be bigger than 100,000";
                      }
                      if (double.parse(value) < _minRating) {
                        return "The max rating must be bigger than the min";
                      }
                      return null;
                    },
                    initialValue: "10",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration().copyWith(
                      hintText: "10",
                      label: const Text("Max Rating"),
                    ),
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        return;
                      }
                      _maxRating = double.parse(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // notification checkbox
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value: _sendNotifications,
                  onChanged: (value) {
                    setState(() => _sendNotifications = value!);
                  },
                ),
                const Text("Send Notifications", textAlign: TextAlign.center),
              ],
            ),
          ),

          // notification frequency
          if (_sendNotifications)
            Expanded(
              child: DropdownButtonFormField<KFrequency>(
                value: _selectedFrequency,
                onChanged: (value) {
                  setState(() => _selectedFrequency = value!);
                },
                items: KFrequency.values
                    .where((element) => element != KFrequency.none)
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.name[0].toUpperCase() + e.name.substring(1),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
