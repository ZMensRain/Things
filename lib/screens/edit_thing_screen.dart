import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:rate_a_thing/helpers/background_task.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';

import 'package:rate_a_thing/screens/thing_detail_screen.dart';
import 'package:rate_a_thing/widgets/ratings/delete_thing_dialog.dart';

class EditThingScreen extends StatefulWidget {
  const EditThingScreen(this.thing, {super.key});
  final Thing thing;
  @override
  State<EditThingScreen> createState() => _EditThingScreenState();
}

class _EditThingScreenState extends State<EditThingScreen> {
  Color _selectedColor = Colors.red;

  KFrequency _selectedFrequency = KFrequency.daily;

  String _enteredTitle = '';

  bool _sendNotifications = false;

  DateTime? date;

  TimeOfDay? time;

  final _formKey = GlobalKey<FormState>();

  late Isar isar;

  @override
  void initState() {
    super.initState();
    _sendNotifications = widget.thing.notifications;
    _selectedFrequency = widget.thing.notificationFrequency;
    _selectedColor = Color(widget.thing.colorValue);
    isar = Isar.getInstance()!;
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    cancleTask(widget.thing.id);

    if (_sendNotifications) {
      if (date == null || time == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Time and date must be set.")));
        return;
      }
      registerBackgroundTask(
          date!.copyWith(
            hour: time!.hour,
            minute: time!.minute,
          ),
          _selectedFrequency,
          _enteredTitle,
          widget.thing.id);
    }

    final thing = widget.thing.copyWith(
      colorValue: _selectedColor.value,
      title: _enteredTitle,
      notificationFrequency: _selectedFrequency,
      notifications: _sendNotifications,
    );

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThingDetailScreen(thing),
      ),
    );
    await isar.writeTxn(
      () => isar.things.put(
        thing.copyWith(
          colorValue: _selectedColor.value,
          notificationFrequency: _selectedFrequency,
          notifications: _sendNotifications,
          title: _enteredTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        actions: [
          IconButton(onPressed: _saveChanges, icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 600,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title field
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Title"),
                    hintText: "Leg Day",
                  ),
                  initialValue: widget.thing.title,
                  validator: titleValidator,
                  onSaved: (newValue) {
                    _enteredTitle =
                        newValue![0].toUpperCase() + newValue.substring(1);
                  },
                ),
                const SizedBox(height: 16),

                // Color Selector
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedColor.value,
                    items: kColors
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.value,
                            child: Container(
                              color: c,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedColor = Color(value!));
                    },
                  ),
                ),

                // Notification frequency selector
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                          value: _sendNotifications,
                          onChanged: (value) {
                            setState(() => _sendNotifications = value!);
                          }),
                      const Text("Send Notifications"),
                    ],
                  ),
                ),
                if (_sendNotifications)
                  Expanded(
                    child: DropdownButtonFormField<KFrequency>(
                      value: _selectedFrequency,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selectedFrequency = value);
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

                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DeleteThingDialog(
                      () async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        await isar.writeTxn(
                          () {
                            isar.things.delete(widget.thing.id);
                            return isar.ratings
                                .filter()
                                .thingIdEqualTo(widget.thing.id)
                                .deleteAll();
                          },
                        );
                      },
                    ),
                  ),
                  child: Text(
                    "Delete",
                    style: const TextStyle()
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
