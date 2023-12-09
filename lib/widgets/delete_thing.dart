import 'package:flutter/material.dart';

class DeleteThingDialog extends StatelessWidget {
  const DeleteThingDialog(this.onDeleteTaped, {super.key});
  final void Function() onDeleteTaped;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure you want to delete?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: const TextStyle()
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: onDeleteTaped,
          child: Text(
            "Yes delete",
            style: const TextStyle()
                .copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}
