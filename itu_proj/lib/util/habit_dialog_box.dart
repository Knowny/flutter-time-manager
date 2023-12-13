// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

class HabitDialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  HabitDialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 300,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // * USER INPUT - HABIT NAME
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: "Add a new habit",
            ),
          ),
          // todo * USER INPUT - HABIT DURATION
          // todo * USER INPUT - HABIT CATEGORY
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // * SAVE BUTTON
              MyButtonPrimary(
                text: "Save",
                onPressed: onSave,
              ),
              const SizedBox(
                width: 8,
              ),
              // * CANCEL BUTTON
              MyButtonSecondary(
                text: "Cancel",
                onPressed: onCancel,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
