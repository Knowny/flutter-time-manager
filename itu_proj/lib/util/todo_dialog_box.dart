import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
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
        height: 200,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //get user input
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: "Add a new task",
            ),
          ),

          //save + cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //save button
              MyButtonPrimary(
                text: "Save",
                onPressed: onSave,
              ),

              const SizedBox(
                width: 8,
              ),

              //cancel button
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
