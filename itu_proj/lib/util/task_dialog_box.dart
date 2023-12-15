// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

class TaskDialogBox extends StatelessWidget {
  final taskNameController;
  VoidCallback onSave;
  VoidCallback onCancel;

  TaskDialogBox({
    super.key,
    required this.taskNameController,
    required this.onSave,
    required this.onCancel,
  });

  // * SNACKBAR - TASK ADDED
  final snackBar = SnackBar(
    content: Text(
      'Task added successfully',
      style: TextStyle(color: Colors.grey.shade900),
    ),
    backgroundColor: Colors.lightGreen.withOpacity(0.5),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 200,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // todo fix later
          const Text('Task name:'),
          // * USER INPUT - TASK NAME
          TextField(
            controller: taskNameController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: "Add a new Task",
            ),
          ),
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
