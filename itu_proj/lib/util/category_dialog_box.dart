///---------------------------
/// file: category_dialog_box.dart
/// author(s): xmager00, xhusar11
///---------------------------
import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class CategoryDialogBox extends StatefulWidget {
  final categoryNameController;
  final categoryColorController;
  VoidCallback onSave;
  VoidCallback onCancel;

  CategoryDialogBox({
    Key? key,
    required this.categoryNameController,
    required this.categoryColorController,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _CategoryDialogBoxState createState() => _CategoryDialogBoxState();
}

class _CategoryDialogBoxState extends State<CategoryDialogBox> {
  // variable to store the selected color
  Color selectedColor = Colors.red;

  MaterialColor getColorFromHex(String hexColor) {
    if (hexColor.isEmpty) return Colors.red;

    if (hexColor[0] == '#') {
      hexColor = hexColor.substring(1);
    }

    int parsedColor = int.parse(hexColor, radix: 16);

    Color color = Color(parsedColor);

    // Create MaterialColor from Color object
    return MaterialColor(color.value, {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }

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
                  String colorString =
                      color.value.toRadixString(16).substring(2);
                  widget.categoryColorController.text = '#$colorString';
                });
              },
              selectedColor: (widget.categoryColorController.text.isNotEmpty)
                  ? getColorFromHex(widget.categoryColorController.text)
                  : Colors.red,
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
              controller: widget.categoryNameController,
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
                  onPressed: widget.onSave,
                ),
                const SizedBox(
                  width: 8,
                ),
                MyButtonSecondary(
                  text: 'Cancel',
                  onPressed: widget.onCancel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
