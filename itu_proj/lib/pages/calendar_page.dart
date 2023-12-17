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
// refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  //midnight of that day
  DateTime selectedDay = DateTime.now();

  final _controller = TextEditingController();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  } 

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

  void editActivity(String name) {
    Future dialogResult = showDialog(
      context: context,
      builder: (context) {
        return ActivityDialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          selectedDay: selectedDay,
          saveActivity: putActivityToDatabase,
          deleteActivity: deleteActivityFromDatabase,
          activity: db.getActivity(name),
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
                  ),
                ),
              ),
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
      floatingActionButton: (selectedDay.isBefore(DateTime.now())) //.add(const Duration(days: 1))
          ? FloatingActionButton(
              onPressed: createNewActivity,
              child: const Icon(Icons.add),
            )
          : null,
    );
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