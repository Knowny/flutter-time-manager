/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/todo_dialog_box.dart';
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

  DateTime today = DateTime.now();

  final _controller = TextEditingController();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
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
   
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return DialogBox(
                controller: _controller,
                onSave: saveNewTask,  // TODO CHECK NON EMPTY AND LENGTH OF THE TEXT
                onCancel: () => Navigator.of(context).pop(),
              );
          });
        },
      ),
      body: Column(
        children: [
          Container(
              child: TableCalendar(
                // locale: , // localization stuff
                rowHeight: 50,
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true), // disable the additional button in the header
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                onDaySelected: _onDaySelected,
              ),
              // color: Colors.yellow,
              // child: Center(
              //   child: Text(
              //     'Calendar Tab Content',
              //   ),
              // ),
            ),
          Text("selected day =" + today.toString().split(" ")[0]),
        ],
      ),
    );
  }
}