/// author(s): xjesko01
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_pick.dart';
import 'package:itu_proj/util/category_tile.dart';
import 'package:itu_proj/util/my_button.dart';

class ActivityDialogBox extends StatefulWidget {
  final dynamic controller;
  VoidCallback onCancel;
  DateTime selectedDay;
  List<dynamic> activity;
  final void Function(List<dynamic>,bool,int?) saveActivity;
  final void Function(List<dynamic>) deleteActivity;

  ActivityDialogBox({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.selectedDay,
    this.saveActivity = _defaultSaveActivity,
    this.deleteActivity = _defaultDeleteActivity,
    this.activity = const [],
  });

  static void _defaultSaveActivity(List<dynamic> newActivity, bool isNew, int? index) {}
  static void _defaultDeleteActivity(List<dynamic> activity) {}

  @override
  State<ActivityDialogBox> createState() => _ActivityDialogBox();
}

class _ActivityDialogBox extends State<ActivityDialogBox>{
  String categoryPickedName = "";
  bool categoryPicked = false;
  Duration? selectedDuration = const Duration();
  Duration? startTime;
  Duration? endTime;

  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  @override
  void initState() {
    // 1st time ever opening app -> create default data
    if (_myBox.get("ACTIVITYLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.activity.isNotEmpty){
      widget.controller.text = widget.activity[0];
    } else if (db.getActivity(widget.controller.text).isNotEmpty){
      widget.controller.clear();
    }
    print(widget.activity);
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 350,
        width: 400,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //picking activity name
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      border: const OutlineInputBorder(),
                      hintText: (widget.activity.isEmpty) ? "Add activity name" : widget.activity[0],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                //showing delete button
                if (widget.activity.isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed: () => widget.deleteActivity(widget.activity),
                    ),
                  ),
              ]
            ),
          Row(
            children: [
            // picking category
              const Text(
                "Category:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 50),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CategoryBox(
                        categoryList: db.categoryList,
                        onCategorySelected: (selectedCategory) {
                            setState(() {
                              categoryPickedName = selectedCategory;
                              categoryPicked = true;
                            });
                        },
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    CategoryTile(
                        categoryName: 
                        (categoryPickedName == "" && widget.activity.isEmpty) ? "Category" : 
                        (categoryPickedName == "") ? widget.activity[1] : categoryPickedName, 
                        categoryColor: db.getCategoryColor(
                          (categoryPickedName == "" && widget.activity.isEmpty) ? "Category" : 
                          (categoryPickedName == "") ? widget.activity[1] : categoryPickedName),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                // picking start time
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 96, 96, 96)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: CupertinoTimerPicker(
                            onTimerDurationChanged: (newTime) {
                              setState(() {
                                startTime = newTime;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          startTime != null
                              ? formatDuration(startTime!)
                              : ((widget.activity.isNotEmpty)) ? formatDayTime(getStartTime(widget.activity)) : 'Select Start Time',
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                // picking end time
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 96, 96, 96)),

                  ),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: CupertinoTimerPicker(
                            onTimerDurationChanged: (newTime) {
                              setState(() {
                                endTime = newTime;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          endTime != null
                              ? formatDuration(endTime!)
                              : ((widget.activity.isNotEmpty)) ? formatDayTime(widget.activity[2]) : 'Select End Time',
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          //save + cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //save button
              (widget.activity.isEmpty) ?
              MyButtonPrimary(
                text: "Save",
                onPressed: saveNewActivity,
              )
              :
              MyButtonPrimary(
                text: "Edit",
                onPressed: saveNewActivity,
              ),

              const SizedBox(
                width: 100,
              ),

              //cancel button
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

  DateTime getStartTime(List<dynamic> activity) {
    Duration duration = activity[3];
    DateTime endTime = activity[2];

    DateTime startTime = endTime.subtract(duration);
    
    return startTime;
  }
  
  DateTime durationToDateTime(Duration? duration, DateTime baseDate) {
    if (duration == null){
      return baseDate;
    }

    return DateTime(baseDate.year, baseDate.month, baseDate.day).add(duration);
  }

  // ["ACTIVITY_NAME", "CATEGORY", date(dateTime), timeSpent (seconds)]
  void saveNewActivity() {
    DateTime newStart = durationToDateTime(startTime, widget.selectedDay);
    DateTime newEnd = durationToDateTime(endTime, widget.selectedDay);

    if (widget.activity.isNotEmpty && !categoryPicked){
        categoryPickedName = widget.activity[1];
        categoryPicked = true;
    }

    if (!checkStartEnd(newStart, newEnd)) {
      _showErrorInvalidTimes(context);
    } else if (!checkFutureTest(newStart, newEnd)) {
      _showErrorInFuture(context);
    } else if (!checkName()) {
      _showErrorEmptyName(context);
    } else if (!checkEmptyTimes()) {
      _showErrorEmptyTimes(context);
    }else if (!checkDuration()) {
      _showErrorZeroDuration(context);
    } else if (!checkCategory()) {
      _showErrorEmptyCategory(context);
    }else {
      List<dynamic> newActivity = [widget.controller.text, categoryPickedName, newEnd, calculateDuration(startTime, endTime)];
      if (widget.activity.isEmpty) {
        widget.saveActivity(newActivity, true, null);
      } else {
        int index = db.activityList.indexOf(widget.activity);
        widget.saveActivity(newActivity, false, index);
      }
    }
  }

  bool checkFutureTest(DateTime startTime, DateTime endTime){    
    //? Check the duration start and end so you don't create something in the future
    DateTime now = DateTime.now();
    if (startTime.isAfter(now) || endTime.isAfter(now)) {
      return false;
    }
    return true;
  }

  bool checkStartEnd(DateTime startTime, DateTime endTime){  
    //? Check that the start duration isn't later than the end duration or naturally reverse it
    if (startTime.isAfter(endTime)) {
      return false;
    }
    return true;
  }
  
  bool checkName(){    
    //? Check if the activity name is not empty
    if (widget.controller.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool checkCategory() {
    if (!categoryPicked){
      return false;
    }
    return true;
  }
  
  bool checkDuration(){
    if (startTime == endTime) {
      return false;
    }
    return true;
  }

  bool checkEmptyTimes(){
    if (startTime == null || endTime == null) {
      return false;
    }
    return true;
  }

  Duration calculateDuration(Duration? startTime, Duration? endTime) {
    if (startTime == null || endTime == null) {
      return const Duration(hours: 0, minutes: 0, seconds: 0);
    }

    return (startTime - endTime).abs();
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);
    
    String period = (hours >= 12) ? 'PM' : 'AM';

    if (hours > 12) {
      hours -= 12;
    }

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString $period';
  }

  String formatDayTime(DateTime time) {
    int hours = time.hour;
    int minutes = time.minute;
    int seconds = time.second;
    String period = (hours >= 12) ? 'PM' : 'AM';

    if (hours > 12) {
      hours -= 12;
    }

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString $period';
  }

  // empty name
  void _showErrorEmptyName(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid activity name.'),
          content: const Text('Activity name can not be empty.'),
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

  // wrong times, one of them in the future
  void _showErrorInFuture(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid time.'),
          content: const Text('Activities can not be created in the future.'),
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

  // wrong times, start is later than end
  void _showErrorInvalidTimes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid time.'),
          content: const Text('Start of activity can not be later than end of activity'),
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

  // wrong times, one of them is empty
  void _showErrorEmptyTimes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid time.'),
          content: const Text('Start and end time must be set!'),
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

  // wrong times, they are equal
  void _showErrorZeroDuration(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid time.'),
          content: const Text('Activity can not have duration of 0'),
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

  //category was not chosen
  void _showErrorEmptyCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid category.'),
          content: const Text('Category must be picked.'),
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

}
