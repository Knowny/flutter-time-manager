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
      // backgroundColor: const Color.fromARGB(255, 20, 18, 24),
      content: Container(
        height: 200,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //get user input
          TextField(
            controller: controller,
            // style: TextStyle(color: const Color.fromARGB(255, 230, 224, 233)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add a new task",
              // hintStyle: TextStyle(color: const Color.fromARGB(255, 230, 224, 233)),
            ),
          ),

          //save + cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //save button
              MyButton(
                text: "Save",
                onPressed: onSave,
              ),

              const SizedBox(
                width: 8,
              ),

              //cancel button
              MyButton(
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
