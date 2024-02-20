/// author(s): xhusar11
import 'package:flutter/material.dart';

// https://api.flutter.dev/flutter/material/SnackBar-class.html
// https://api.flutter.dev/flutter/material/AlertDialog-class.html

// *========================== SNACKBARS AND ALERTS ==========================*//

// * SNACKBAR - TASK ADDED
void taskAddedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Task added successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.lightGreen.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * SNACKBAR - TASK EDITED
void taskEditedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Task edited successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.grey.shade300.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * SNACKBAR - TASK DELETED
void taskDeletedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Task deleted successfully',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * SNACKBAR - HABIT ADDED
void habitAddedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Habit added successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.lightGreen.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * SNACKBAR - HABIT EDITED
void habitEditedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Habit edited successfully',
        style: TextStyle(color: Colors.grey.shade900),
      ),
      backgroundColor: Colors.grey.shade300.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * SNACKBAR - HABIT DELETED
void habitDeletedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Habit deleted successfully',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      width: 220.0,
    ),
  );
}

// * EMPTY NAME ALERT - TASK
void showEmptyNameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Invalid Task name.'),
        content: const Text('Task name can not be empty.'),
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

// * EMPTY NAME ALERT - HABIT
void showEmptyHabitNameDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Invalid Habit name.'),
        content: const Text('Habit name can not be empty.'),
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

// * EMPTY DURATION ALERT - HABIT
void showEmptyHabitDurationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Set the habit duration.'),
        content: const Text('Habit duration can not be 00:00:00.'),
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

// * ADD HABIT TO FAVOURITES (timer still running) DIALOG
void addHabitToFavouritesWhileActiveDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Turn of the Habit timers.'),
        content: const Text(
            'In order to set Habit as favourite, turn of all Habit timers.'),
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
