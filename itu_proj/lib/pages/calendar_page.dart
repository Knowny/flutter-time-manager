/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/activity_dialog_box.dart';
import 'package:itu_proj/util/activity_list.dart';
import 'package:table_calendar/table_calendar.dart';

// source: https://github.com/aleksanderwozniak/table_calendar

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  DateTime selectedDay = DateTime.now();

  final _controller = TextEditingController();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  } 

  @override
  void initState() {
    if (_myBox.get("ACTIVITYLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }
  
  void createNewActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          selectedDay: selectedDay,
          saveActivity: putActivityToDatabase,
        );
      },
    );
  }

  void putActivityToDatabase(List<dynamic> newActivity, bool isNew, int? index){
    setState(() {
        if (isNew){
          db.activityList.add(newActivity);
          _activityAddedSnackBar(context);
        } else {
          if (index != null) {
            db.activityList[index] = newActivity;
            _activityEditedSnackBar(context);
          }
        }
      }
    );
    _controller.clear();
    db.updateDataBase();
    Navigator.of(context).pop();
  }

  void editActivity(int index) {
    Future dialogResult = showDialog(
      context: context,
      builder: (context) {
        return ActivityDialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          selectedDay: selectedDay,
          saveActivity: putActivityToDatabase,
          deleteActivity: deleteActivityFromDatabase,
          activity: db.getActivityByIndex(index),
        );

      },
    );
    dialogResult.then((result) {
    if (result != null && result == false) {
      _controller.clear();
    }
    });
  }

  void deleteActivityFromDatabase(List<dynamic> activityToDelete){
    setState(() {
      db.activityList.remove(activityToDelete);
    });
    _activityDeletedSnackBar(context);
    db.updateDataBase();
    _controller.clear();
    Navigator.of(context).pop();
  }

  Widget _buildMarkers(DateTime date, List<dynamic> activities) {
    // building marker if there are activities
    if (activities.isNotEmpty) {
      return Positioned(
        top: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getActivityColor(activities),
          ),
          width: 5,
          height: 5,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    List<dynamic> activities = db.getActivitiesByDay(selectedDay);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                // displaying calendar
                child: SizedBox(
                  height: 290,
                  width: 325,
                  child: TableCalendar(
                    rowHeight: 35,
                    headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                    availableGestures: AvailableGestures.all,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                    focusedDay: selectedDay,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 10, 16),
                    onDaySelected: _onDaySelected,
                    calendarStyle: const CalendarStyle(
                      weekendTextStyle: TextStyle(color: Colors.orangeAccent),
                      outsideTextStyle: TextStyle(color: Colors.grey),
                    ),
                    eventLoader: (day) {
                      return db.getActivitiesByDay(day);
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        return _buildMarkers(date, events);
                      },
                    ),
                  ),
                ),
              ),
              // displaying activities
              SizedBox(
                height: 300,
                child: (activities.isNotEmpty)
                    ? ActivitiesList(
                        activities: activities,
                        editActivity: editActivity,
                        db: db,
                      )
                    : const Text("No activities for the selected day."),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (selectedDay.isBefore(DateTime.now()))
          ? FloatingActionButton(
              onPressed: createNewActivity,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

Color getActivityColor(List<dynamic> activities) {
  // get the color of category with most activities
  Map<String, int> categoryCount = {};

  for (var activity in activities) {
    if (activity.length > 1) {
      String category = activity[1].toString();
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
  }

  String mostRepresentedCategory = categoryCount.keys.reduce((a, b) =>
      categoryCount[a]! > categoryCount[b]! ? a : b);

  return db.getCategoryColor(mostRepresentedCategory);
  }

  // activity created notify
  void _activityAddedSnackBar(BuildContext context) {
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

  // activity edited notify
  void _activityEditedSnackBar(BuildContext context) {
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

  // activity deleted notify
  void _activityDeletedSnackBar(BuildContext context) {
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
}