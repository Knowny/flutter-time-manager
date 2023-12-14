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

  ActivityDialogBox({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.selectedDay,
  });

  @override
  State<ActivityDialogBox> createState() => _ActivityDialogBox();
}

class _ActivityDialogBox extends State<ActivityDialogBox>{
  String categoryPickedName = "";
  bool categoryPicked = false;
  Duration? selectedDuration = const Duration();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // 1st time ever opening app -> create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 400,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //picking activity name
          TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: "Add activity name",
            ),
          ),
          // picking category
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
                // const SizedBox(width: 8),
                CategoryTile(
                    categoryName: (categoryPickedName == "") ? "Select Category": categoryPickedName, 
                    categoryColor: db.getCategoryColor(categoryPickedName),
                ),
              ],
            ),
          ),
          // Picking start time
           GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 300,
                    child: CupertinoTimerPicker(
                      onTimerDurationChanged: (newTime) {
                        setState(() {
                          startTime = durationToTimeOfDay(newTime, widget.selectedDay);
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
                        ? 'Start Time: ${startTime!.format(context)}'
                        : 'Select Start Time',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            // Picking end time
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context, 
                    builder: (context) => Container(
                      height: 300,
                      child: CupertinoTimerPicker(
                        onTimerDurationChanged: (newTime) {
                          setState(() {
                            endTime = durationToTimeOfDay(newTime, widget.selectedDay);
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
                    endTime != null
                        ? 'End Time: ${endTime!.format(context)}'
                        : 'Select End Time',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          //save + cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //save button
              MyButtonPrimary(
                text: "Save",
                onPressed: saveNewActivity,
              ),

              const SizedBox(
                width: 8,
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
  
  TimeOfDay? durationToTimeOfDay(Duration duration, DateTime baseDate) {
    DateTime dateTime = DateTime(baseDate.year, baseDate.month, baseDate.day).add(duration);
    return TimeOfDay.fromDateTime(dateTime);
  }

  // ["ACTIVITY_NAME", "CATEGORY", date(dateTime), timeSpent (seconds)]
  void saveNewActivity() {
    if (!checkStartEnd(startTime, endTime) || !checkFutureTest(startTime, endTime) || !checkName()) {
      // TODO HANDLE ERROR ASK TOMAS
    }
    List<dynamic> newActivity = [widget.controller.text, categoryPickedName, getDateTime(endTime), calculateDuration(startTime, endTime)];
    setState(() {
      db.activityList.add(newActivity);
    });
    db.updateDataBase();
    Navigator.of(context).pop();
  }

  bool checkFutureTest(TimeOfDay? startTime, TimeOfDay? endTime){    
    //? Check the duration start and end so you don't create something in the future
    DateTime now = DateTime.now();
    DateTime startDateTime = getDateTime(startTime);
    DateTime endDateTime = getDateTime(endTime);
    if (startDateTime.isAfter(now) || endDateTime.isAfter(now)) {
      print('Error: Start time is in the future or End time is in the future');
      return false;
    }
    return true;
  }

  bool checkStartEnd(TimeOfDay? startTime, TimeOfDay? endTime){  
    //? Check that the start duration isn't later than the end duration or naturally reverse it
    DateTime startDateTime = getDateTime(startTime);
    DateTime endDateTime = getDateTime(endTime);
    if (startDateTime.isAfter(endDateTime)) {
      print('Error: Start time is later than end time');
      return false;
    }
    return true;
  }
  
  bool checkName(){    
    //? Check if the activity name is not empty
    if (widget.controller.text.isEmpty) {
      print('Error: Activity name is empty');
      return false;
    }
    return true;
  }

  DateTime getDateTime(TimeOfDay? time){
    if (time == null) {
      //! probably bullshit
      return widget.selectedDay;
    }
    DateTime now = widget.selectedDay;
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Duration calculateDuration(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) {
      return const Duration(hours: 0, minutes: 0, seconds: 0);
    }

    DateTime now = widget.selectedDay;
    DateTime startDate = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDate = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    return endDate.difference(startDate);
  }

}
