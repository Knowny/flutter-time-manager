import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class CategoryDialogBox extends StatefulWidget {
  final categoryNameController;
  final categoryColorController;
  VoidCallback onSave;
  VoidCallback onCancel;
  // VoidCallback onColorChange;

  CategoryDialogBox(
      {Key? key, // Added Key parameter
      required this.categoryNameController,
      required this.categoryColorController,
      required this.onSave,
      required this.onCancel,
      // required this.onColorChange
      })
      : super(key: key); // Use super(key: key)

  @override
  _CategoryDialogBoxState createState() => _CategoryDialogBoxState();
}

class _CategoryDialogBoxState extends State<CategoryDialogBox> {
  // variable to store the selected color
  Color selectedColor = Colors.red;

  // show color picker
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.grey[850],
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: MaterialColorPicker(
              onColorChange: (Color color) {
                setState(() {
                  selectedColor = color;
                  String colorString = color.value.toRadixString(16).substring(2);
                  widget.categoryColorController.text = '#$colorString';
                });
              },
              selectedColor: Colors.red,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.categoryNameController, // Use widget. prefix
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(),
                hintText: 'Category name',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleColor(color: selectedColor, circleSize: 40),
                MyButtonSecondary(
                  text: "Choose color",
                  onPressed: () {
                    _showColorPicker(context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButtonPrimary(
                  text: 'Save',
                  onPressed: widget.onSave, // Use widget. prefix
                ),
                const SizedBox(
                  width: 8,
                ),
                MyButtonSecondary(
                  text: 'Cancel',
                  onPressed: widget.onCancel, // Use widget. prefix
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
