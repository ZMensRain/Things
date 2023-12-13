import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_a_thing/models/thing.dart';
import 'package:rate_a_thing/providers/ratings_provider.dart';
import 'package:rate_a_thing/providers/thing_provider.dart';
import 'package:rate_a_thing/screens/thing_detail_screen.dart';
import 'package:rate_a_thing/widgets/delete_thing_dialog.dart';

class EditThingScreen extends ConsumerStatefulWidget {
  const EditThingScreen(this.thing, {super.key});
  final Thing thing;
  @override
  ConsumerState<EditThingScreen> createState() => _EditThingScreenState();
}

class _EditThingScreenState extends ConsumerState<EditThingScreen> {
  Color _selectedColor = Colors.red;

  KFrequency _selectedFrequency = KFrequency.daily;

  String _enteredTitle = '';

  bool _sendNotifications = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sendNotifications = widget.thing.notifications;
    _selectedFrequency = widget.thing.notificationFrequency;
    _selectedColor = widget.thing.color;
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final thing = widget.thing.copyWith(
      color: _selectedColor,
      title: _enteredTitle,
      notificationFrequency:
          _sendNotifications ? _selectedFrequency : KFrequency.none,
      notifications: _sendNotifications,
    );
    ref.read(thingsProvider.notifier).editAThing(
          widget.thing,
          thing,
        );
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    ref.read(ratingsProvider(thing).notifier).loadRatingsSQL();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ThingDetailScreen(thing),
    ));
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
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                          value: _sendNotifications,
                          onChanged: (value) {
                            _selectedFrequency =
                                _selectedFrequency == KFrequency.none
                                    ? KFrequency.daily
                                    : _selectedFrequency;

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

                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DeleteThingDialog(() {
                      ref
                          .read(thingsProvider.notifier)
                          .deleteAThing(widget.thing);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
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
