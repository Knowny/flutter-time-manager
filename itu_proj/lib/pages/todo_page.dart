/// author(s): xhusar11
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/habit_dialog_box.dart';
import 'package:itu_proj/util/habit_tile.dart';
import 'package:itu_proj/util/task_dialog_box.dart';
import 'package:itu_proj/util/todo_segmented_button.dart';
import '../util/task_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

// * AUTOMATIC KEEP ALIVE
//https://stackoverflow.com/questions/65657495/flutter-debuglifecyclestate-elementlifecycle-defunct-is-not-true

class _TodoPageState extends State<TodoPage>
    with AutomaticKeepAliveClientMixin {
  // select tasks
  Selector selectorView = Selector.Tasks;

  // refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // notifications
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // 1st time ever opening app -> create default data
    if ((_myBox.get("TASKLIST") == null) && (_myBox.get("HABITLIST") == null)) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  // send notification (android only)
  triggerNotification(String habitName) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Habit Completed',
        body: '${habitName} is Completed!',
      ),
    );
  }

  // convert HH:mm:ss(string) to seconds(int)
  int hhmmss2Seconds(String timeString) {
    List<String> parts = timeString.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return ((hours * 3600) + (minutes * 60) + seconds);
  }

  // convert seconds(int) to HH:mm:ss(string)
  String seconds2hhmmss(int timeSeconds) {
    int hours = timeSeconds ~/ 3600;
    int minutes = (timeSeconds % 3600) ~/ 60;
    int seconds = (timeSeconds % 3600) % 60;

    // HH:mm:ss format
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // * Task name controller
  final _taskNameController = TextEditingController();

  // * Habit name controller
  final _habitNameController = TextEditingController();
  // * Habit duration controller
  final _habitDurationController = TextEditingController();

  // * ADD/REMOVE HABIT TO/FROM FAVOURITES
  void addHabitToFavourites(int index) {
    // variable for running timer check
    bool habitTimerActive = false;

    // any timer is running -> habitTimerActive = true
    for (var i = 0; i < db.habitList.length; i++) {
      if (db.habitList[i][2] == true) {
        habitTimerActive = true;  
      }
    }

    // if no timer is running
    if (!habitTimerActive) {
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
    } else {
      // alert the user to turn off the timer(s)
      _addHabitToFavouritesWhileActiveDialog(context);
    }
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
              // check if the spentTime(sec) is bigger thank the durationTime(sec)
              if ((db.habitList[index][3] >= (db.habitList[index][4]))) {
                // send notification
                triggerNotification(db.habitList[index][0]);

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
          habitNameController: _habitNameController,
          habitDurationController: _habitDurationController,
          onSave: saveNewHabit,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // * SAVE NEW HABIT
  void saveNewHabit() {
    String newHabitName = _habitNameController.text;

    int habitDuration = 0;

    if (_habitDurationController.text.isNotEmpty) {
      habitDuration = hhmmss2Seconds(_habitDurationController.text);
    }

    if ((newHabitName.isNotEmpty) && (habitDuration > 0)) {
      setState(() {
        db.habitList.add(
            [_habitNameController.text, false, false, 0, habitDuration, false]);
        _habitNameController.clear();
        _habitDurationController.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else if ((newHabitName.isNotEmpty) && (habitDuration <= 0)) {
      _showEmptyHabitDurationDialog(context);
    } else {
      _showEmptyHabitNameDialog(context);
    }
  }

  // * EDIT HABIT
  void editHabit(int index) {
    String currentHabitName = db.habitList[index][0];
    _habitNameController.text = currentHabitName;
    String currentHabitDuration = seconds2hhmmss(db.habitList[index][4]);
    _habitDurationController.text = currentHabitDuration;

    showDialog(
      context: context,
      builder: (context) {
        return HabitDialogBox(
            habitNameController: _habitNameController,
            habitDurationController: _habitDurationController,
            onSave: () {
              saveExistingHabit(index, _habitNameController.text,
                  _habitDurationController.text);
            },
            onCancel: () {
              Navigator.of(context).pop();
              _habitNameController.clear();
              _habitDurationController.clear();
            });
      },
    );
  }

  // * SAVE EXISTING HABIT
  void saveExistingHabit(int index, String newName, String newDuration) {
    if ((newName.isNotEmpty) && (hhmmss2Seconds(newDuration) > 0)) {
      setState(() {
        db.habitList[index][0] = newName;
        db.habitList[index][4] = hhmmss2Seconds(newDuration);
        _habitNameController.clear();
        _habitDurationController.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else if ((newName.isNotEmpty) && (hhmmss2Seconds(newDuration) <= 0)) {
      _showEmptyHabitDurationDialog(context);
    } else {
      _showEmptyHabitNameDialog(context);
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

  // * EMPTY NAME ALERT - HABIT
  void _showEmptyHabitNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid habit name.'),
          content: Text('Habit name can not be empty.'),
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

  // * EMPTY DURATION ALERT - HABIT
  void _showEmptyHabitDurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set the habit duration.'),
          content: Text('Habit duration can not be 00:00:00.'),
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

  // * ADD HABIT TO FAVOURITES (timer still running) DIALOG
  void _addHabitToFavouritesWhileActiveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Turn of the Habit timers.'),
          content: Text(
              'In order to set Habit as favourite, turn of all Habit timers.'),
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
      db.taskList[index][1] = !db.taskList[index][1];
    });
    db.updateDataBase();
  }

  // * ADD/REMOVE TASK TO/FROM FAVOURITES
  void addTaskToFavourites(int index) {
    setState(() {
      db.taskList[index][2] = !db.taskList[index][2];
    });

    // https://api.flutter.dev/flutter/dart-core/List/sort.html
    // sort the list, so the favourites are before the non-favourites
    db.taskList.sort((a, b) {
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
        return TaskDialogBox(
          // text controller
          taskNameController: _taskNameController,
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
    String newTaskName = _taskNameController.text;
    if (newTaskName.isNotEmpty) {
      setState(() {
        // taskName, isCompleted, isFavourite
        db.taskList.add([_taskNameController.text, false, false]);
        _taskNameController.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      _showEmptyNameDialog(context);
    }
  }

  // * EDIT TASK
  void editTask(int index) {
    String currentTaskName = db.taskList[index][0];
    _taskNameController.text = currentTaskName;

    showDialog(
      context: context,
      builder: (context) {
        return TaskDialogBox(
            taskNameController: _taskNameController,
            onSave: () {
              saveExistingTask(index, _taskNameController.text);
            },
            onCancel: () {
              Navigator.of(context).pop();
              _taskNameController.clear();
            });
      },
    );
  }

  // * SAVE EXISTING TASK
  void saveExistingTask(int index, String newName) {
    if (newName.isNotEmpty) {
      setState(() {
        db.taskList[index][0] = newName;
        _taskNameController.clear();
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
      db.taskList.removeAt(index);
    });
    db.updateDataBase();
  }

  // * BUILD PAGE
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    itemCount: db.taskList.length,
                    itemBuilder: (context, index) {
                      bool isLastTile = index == db.taskList.length - 1;

                      return Padding(
                        // * ADD A BOTTOM PADDING ONLY TO THE LAST TILE (because of the floating button)
                        padding:
                            EdgeInsets.only(bottom: isLastTile ? 64.0 : 0.0),
                        child: TaskTile(
                          taskName: db.taskList[index][0],
                          taskCompleted: db.taskList[index][1],
                          taskFavourited: db.taskList[index][2],
                          onChanged: (value) => checkBoxChanged(value, index),
                          addToFavouritesFunction: (context) =>
                              addTaskToFavourites(index),
                          editFunction: (context) => editTask(index),
                          deleteFunction: (context) => deleteTask(index),
                        ),
                      );
                    },
                  )
                :
                // * BUILD LIST - HABITS
                ListView.builder(
                    itemCount: db.habitList.length,
                    itemBuilder: (context, index) {
                      bool isLastTile = index == db.habitList.length - 1;

                      return Padding(
                        // * ADD A BOTTOM PADDING ONLY TO THE LAST TILE (because of the floating button)
                        padding:
                            EdgeInsets.only(bottom: isLastTile ? 64.0 : 0.0),
                        child: HabitTile(
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
                        ),
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
