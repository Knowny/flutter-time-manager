/// author(s): xhusar11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/habit_dialog_box.dart';
import 'package:itu_proj/util/habit_tile.dart';
import 'package:itu_proj/util/todo_dialog_box.dart';
import 'package:itu_proj/util/todo_segmented_button.dart';
import '../util/todo_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // select tasks
  Selector selectorView = Selector.Tasks;

  // refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // 1st time ever opening app -> create default data
    if ((_myBox.get("TODOLIST") == null) && (_myBox.get("HABITLIST") == null)) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }

  // * TEXT CONTROLLER
  final _controller = TextEditingController();

  // todo format the time accordingly

  // * ADD/REMOVE HABIT TO/FROM FAVOURITES
  void addHabitToFavourites(int index) {
    setState(() {
      db.habitList[index][5] = !db.habitList[index][5];
    });

    // https://api.flutter.dev/flutter/dart-core/List/sort.html
    // sort the list, so the favourites are before the non-favourites
    db.habitList.sort((a, b) {
      if (a[5] && !b[5]) {
        return -1; // a = true, b = false -> a should be before b
      } else if (!a[5] && b[5]) {
        return 1; // a = false, b = true -> b should be before a
      } else {
        return 0; // a = b -> dont change the order
      }
    });
    db.updateDataBase();
  }

  // * START/STOP HABIT TIMER
  void habitTimer(int index) {
    // get the start time
    var startTime = DateTime.now();
    // get the time already spent
    int spentTime = db.habitList[index][3];
    // (habitCompleted = true, habitActive = false)
    if (db.habitList[index][1] && !db.habitList[index][2]) {
      // * HABIT PAUSED AND COMPLETED -> RESET THE TIMER
      setState(() {
        // habitCompleted
        db.habitList[index][1] = false;
        // timeSpent
        db.habitList[index][3] = 0;
      });
      db.updateDataBase();
    } else {
      // * HABIT NOT PAUSED AND COMPLETED
      // start/stop timer
      setState(() {
        // habitActive
        db.habitList[index][2] = !db.habitList[index][2];
      });
      db.updateDataBase();

      // used, because the time in db is stored in seconds, not milliseconds
      var iterator = 0;
      // check if habit is active
      if (db.habitList[index][2]) {
        Timer.periodic(Duration(milliseconds: 100), (timer) {
          setState(() {
            // check if the user stopped the timer
            if (!db.habitList[index][2]) {
              timer.cancel();
            }
            // get the current time
            var currentTime = DateTime.now();
            // 100ms has passed
            iterator++;
            // if whole second passed, increment the time in the db
            if (iterator >= 10) {
              // rewrite the time spent by calculating spent time + curr time - start time
              db.habitList[index][3] = spentTime +
                  currentTime.second -
                  startTime.second +
                  60 * (currentTime.minute - startTime.minute) +
                  60 * 60 * (currentTime.hour - startTime.hour);
              iterator = 0;
            }
            // if the activity is not yet completed
            if (db.habitList[index][1] == false) {
              // check if the spentTime is bigger thank the durationTime
              if ((db.habitList[index][3] >= (db.habitList[index][4]) * 60)) {
                // set the habit state to completed
                db.habitList[index][1] = true;
              }
            }
          });
        });
      }
    }
  }

  // * CREATE NEW HABIT
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return HabitDialogBox(
          // todo moore controllers
          controller: _controller,
          onSave: saveNewHabit,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // * SAVE NEW HABIT
  void saveNewHabit() {
    String newHabitName = _controller.text;
    if (newHabitName.isNotEmpty) {
      setState(() {
        db.habitList.add([_controller.text, false]);
        _controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      _showEmptyNameDialog(context); // todo dialog for the habit
    }
  }

  // * EDIT HABIT
  void editHabit(int index) {
    String currentHabitName = db.toDoList[index][0];
    _controller.text = currentHabitName;

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: () {
              saveExistingHabit(index, _controller.text);
            },
            onCancel: () {
              Navigator.of(context).pop();
              _controller.clear();
            });
      },
    );
  }

  // * SAVE EXISTING HABIT
  void saveExistingHabit(int index, String newName) {
    if (newName.isNotEmpty) {
      setState(() {
        db.toDoList[index][0] = newName;
        _controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      _showEmptyNameDialog(context); // todo dialog for habit
    }
  }

  // * DELETE HABIT
  void deleteHabit(int index) {
    setState(() {
      db.habitList.removeAt(index);
    });
    db.updateDataBase();
  }

  // * EMPTY NAME ALERT - TASK
  void _showEmptyNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid task name.'),
          content: Text('Task name can not be empty.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // * TAPPED CHECKBOX - TASK
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // * ADD/REMOVE TASK TO/FROM FAVOURITES
  void addTaskToFavourites(int index) {
    setState(() {
      db.toDoList[index][2] = !db.toDoList[index][2];
    });

    // https://api.flutter.dev/flutter/dart-core/List/sort.html
    // sort the list, so the favourites are before the non-favourites
    db.toDoList.sort((a, b) {
      if (a[2] && !b[2]) {
        return -1; // a = true, b = false -> a should be before b
      } else if (!a[2] && b[2]) {
        return 1; // a = false, b = true -> b should be before a
      } else {
        return 0; // a = b -> dont change the order
      }
    });
    db.updateDataBase();
  }

  // * CREATE NEW TASK
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          // text controller
          controller: _controller,
          // save button
          onSave: saveNewTask,
          // cancel button
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // * SAVE NEW TASK
  void saveNewTask() {
    String newTaskName = _controller.text;
    if (newTaskName.isNotEmpty) {
      setState(() {
        // taskName, isCompleted, isFavourite
        db.toDoList.add([_controller.text, false, false]);
        _controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      _showEmptyNameDialog(context);
    }
  }

  // * EDIT TASK
  void editTask(int index) {
    String currentTaskName = db.toDoList[index][0];
    _controller.text = currentTaskName;

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: () {
              saveExistingTask(index, _controller.text);
            },
            onCancel: () {
              Navigator.of(context).pop();
              _controller.clear();
            });
      },
    );
  }

  // * SAVE EXISTING TASK
  void saveExistingTask(int index, String newName) {
    if (newName.isNotEmpty) {
      setState(() {
        db.toDoList[index][0] = newName;
        _controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      _showEmptyNameDialog(context);
    }
  }

  // * DELETE TASK
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  // * BUILD PAGE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // * SEGMENTED BUTTON
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChoice(
              selectorView: selectorView,
              onSelectionChanged: (Selector newSelection) {
                setState(() {
                  selectorView = newSelection;
                });
              },
            ),
          ),
          Expanded(
            child: (selectorView == Selector.Tasks)

                // * BUILD LIST - TASKS
                ? ListView.builder(
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        taskName: db.toDoList[index][0],
                        taskCompleted: db.toDoList[index][1],
                        taskFavourited: db.toDoList[index][2],
                        onChanged: (value) => checkBoxChanged(value, index),
                        addToFavouritesFunction: (context) =>
                            addTaskToFavourites(index),
                        editFunction: (context) => editTask(index),
                        deleteFunction: (context) => deleteTask(index),
                      );
                    },
                  )
                :
                // * BUILD LIST - HABITS
                ListView.builder(
                    itemCount: db.habitList.length,
                    itemBuilder: (context, index) {
                      return HabitTile(
                        habitName: db.habitList[index][0],
                        habitCompleted: db.habitList[index][1],
                        habitActive: db.habitList[index][2],
                        timeSpent: db.habitList[index][3],
                        timeDuration: db.habitList[index][4],
                        habitFavourited: db.habitList[index][5],
                        onTap: () {
                          habitTimer(index);
                        },
                        addToFavouritesFunction: (context) =>
                            addHabitToFavourites(index),
                        editFunction: (context) => editHabit(index),
                        deleteFunction: (context) => deleteHabit(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: (selectorView == Selector.Tasks)
          // * FLOATING ACTION BUTTON - TASKS
          ? FloatingActionButton(
              onPressed: createNewTask,
              child: const Icon(Icons.add),
            )
          :
          // * FLOATING ACTION BUTTON - HABITS
          FloatingActionButton(
              onPressed: createNewHabit,
              child: const Icon(Icons.add),
            ),
    );
  }
}
