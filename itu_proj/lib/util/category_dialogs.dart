///---------------------------
/// file: category_dialogs.dart
/// author: xmager00
///---------------------------
import 'package:flutter/material.dart';

// category added
void categoryAddedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Category added successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.lightGreen.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 230.0,
    ),
  );
}

// category edited
void categoryEditedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Category edited successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.grey.shade300.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 230.0,
    ),
  );
}

// category deleted
void categoryDeletedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Category deleted successfully',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 230.0,
    ),
  );
}

// empty category name alert
void showEmptyCategoryNameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Invalid Category name.'),
        content: const Text('Category name can not be empty.'),
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