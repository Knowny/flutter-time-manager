/// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

// https://api.flutter.dev/flutter/material/AlertDialog-class.html

// *========================== TASK DIALOG BOX ==========================*//

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 200,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text(
            'Task name:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
