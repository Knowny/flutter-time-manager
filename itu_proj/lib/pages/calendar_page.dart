/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/activity_dialog_box.dart';
import 'package:itu_proj/util/activity_list.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
// refference the hive box
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
    // 1st time ever opening app -> create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }
   
  void saveNewActivity() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }
  void createNewActivity() {
    //TODO CHECK SO THE TIME IS NOT HIGHER THAT NOW()
    showDialog(
      context: context,
      builder: (context) {
        return ActivityDialogBox(
          controller: _controller,
          onSave: saveNewActivity,  // TODO CHECK NON EMPTY AND LENGTH OF THE TEXT
          onCancel: () => Navigator.of(context).pop(),
          db: db,
          selectedDay: selectedDay,
        );
      },
    );
  }

  // delete task
  void deleteActivity(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }
  @override
  Widget build(BuildContext context) {
  List<dynamic> activities = db.getActivitiesByDay(selectedDay);

  return Scaffold(
    body: Container(
        child: Column(
          children: [
            Container(
              height: 290,
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
            Container(
                height: 300,
                child:
                  (activities.isNotEmpty) 
                  ?
                    ActivitiesList(activities: activities)
                  :
                    Text("No activities for the selected day.")
              ),
          ],
        ),
      ),
    floatingActionButton: (selectedDay.isBefore(DateTime.now()))
        ? FloatingActionButton(
            onPressed: createNewActivity,
            child: Icon(Icons.add),
          )
        : null,
    );
  }


}