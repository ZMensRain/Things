import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:rate_a_thing/helpers/background_task.dart';
import 'package:rate_a_thing/helpers/isar_helper.dart' as isar_helper;
import 'package:rate_a_thing/models/thing.dart';

class CreateThingScreen extends StatefulWidget {
  const CreateThingScreen({super.key});

  @override
  State<CreateThingScreen> createState() => _CreateThingScreenState();
}

class _CreateThingScreenState extends State<CreateThingScreen> {
  Color _selectedColor = Colors.red;

  KFrequency _selectedFrequency = KFrequency.daily;

  String _enteredTitle = '';

  bool _sendNotifications = false;

  double _minRating = 0;

  double _maxRating = 10;

  DateTime? date;

  TimeOfDay? time;

  final _formKey = GlobalKey<FormState>();
  late Isar isar;

  @override
  void initState() {
    super.initState();
    isar_helper.open().then((value) => isar = value);
  }

  void _createThing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_sendNotifications && (date == null || time == null)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time and date must be set.")));
      return;
    }

    final Thing thing = Thing(
      _enteredTitle,
      average: null,
      lastTimeRated: null,
      colorValue: _selectedColor.value,
      maxRating: _maxRating,
      minRating: _minRating,
      notifications: _sendNotifications,
      notificationFrequency: _selectedFrequency,
    );

    Navigator.of(context).pop();
    int id = await isar.writeTxn(
      () => isar.things.put(thing),
    );
    registerBackgroundTask(
      date!.copyWith(hour: time!.hour, minute: time!.hour),
      _selectedFrequency,
      thing.title,
      id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Thing"),
        actions: [
          IconButton(
            onPressed: _createThing,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 500,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                // Title field
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Title"),
                    hintText: "💪 Arm Day",
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
                            if (value == null ||
                                double.tryParse(value) == null) {
                              return "A number has to be entred";
                            }
                            if (double.parse(value) < 0) {
                              return "must be bigger than -1";
                            }
                            if (double.parse(value) > 100000) {
                              return "Can't be bigger than 100,000";
                            }
                            if (double.parse(value) > _maxRating) {
                              return "Must be lower than the max";
                            }

                            if (double.parse(value)
                                    .toString()
                                    .split(".")[1]
                                    .length >
                                1) {
                              return "Only one decimal place allowed";
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
                            if (value == null ||
                                double.tryParse(value) == null) {
                              return "A number has to be entred";
                            }
                            if (double.parse(value) < 1) {
                              return "Must be bigger than 0";
                            }
                            if (double.parse(value) > 100000) {
                              return "Can't be bigger than 100,000";
                            }
                            if (double.parse(value) < _minRating) {
                              return "Must be bigger than the min";
                            }
                            if (double.parse(value)
                                    .toString()
                                    .split(".")[1]
                                    .length >
                                1) {
                              return "Only one decimal place allowed";
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
                      const Text("Send Notifications",
                          textAlign: TextAlign.center),
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
                // Notification starting date and time
                if (_sendNotifications)
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365 * 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month)),
                      IconButton(
                        onPressed: () async {
                          time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                        },
                        icon: const Icon(Icons.alarm),
                      ),
                    ],
                  ),

                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
