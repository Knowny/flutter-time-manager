/// author(s): xhusar11
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

// https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
// https://api.flutter.dev/flutter/cupertino/CupertinoTimerPicker-class.html

// *========================== HABIT DIALOG ==========================*//

class HabitDialogBox extends StatefulWidget {
  final habitNameController;
  final habitDurationController;
  VoidCallback onSave;
  VoidCallback onCancel;

  HabitDialogBox({
    super.key,
    required this.habitNameController,
    required this.habitDurationController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _HabitDialogBoxState createState() => _HabitDialogBoxState();
}

class _HabitDialogBoxState extends State<HabitDialogBox> {
  // variable to store the selected time
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);

  // * FORMAT THE DURATION to HH:mm:ss
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  // * TIME PICKER
  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.grey.shade700,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hms,
                      initialTimerDuration: selectedDuration,
                      onTimerDurationChanged: (Duration duration) {
                        setState(() {
                          selectedDuration = duration;
                          // i need the duration as a text in controller
                          widget.habitDurationController.text =
                              '${format(selectedDuration)}';
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      child: const Text('SELECT'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 300,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // todo fix the text
          const Text('Habit name:'),
          // * USER INPUT - HABIT NAME
          TextField(
            controller: widget.habitNameController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: "Add a new Habit",
            ),
          ),
          // todo fix the text
          const Text('Habit duration:'),
          GestureDetector(
            onTap: () {
              _showTimePicker(context);
            },
            child: TextField(
              controller: widget.habitDurationController,
              enabled: false, // disable the text field editing
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                border: const OutlineInputBorder(),
                hintText: '${format(selectedDuration)}',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // * SAVE BUTTON
              MyButtonPrimary(
                text: "Save",
                onPressed: widget.onSave,
              ),
              const SizedBox(
                width: 8,
              ),
              // * CANCEL BUTTON
              MyButtonSecondary(
                text: "Cancel",
                onPressed: widget.onCancel,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
