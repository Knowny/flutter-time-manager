import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/todo_dialog_box.dart';
// import 'package:itu_proj/main.dart';

import '../util/todo_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
// refference the hive box
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

  // text controller
  final _controller = TextEditingController();

  // checkbox tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save a new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // ceate a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('TO DO'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.checklist,
                    color: Color.fromARGB(255, 208, 188, 255),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.bar_chart,
                    color: Color.fromARGB(255, 208, 188, 255),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.timer,
                    color: Color.fromARGB(255, 208, 188, 255),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 208, 188, 255),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // TO DO TAB
                  ListView.builder(
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        taskName: db.toDoList[index][0],
                        taskCompleted: db.toDoList[index][1],
                        onChanged: (value) => checkBoxChanged(value, index),
                        deleteFunction: (context) => deleteTask(index),
                      );
                    },
                  ),
                  // STATISTICS TAB
                  Container(),
                  // TIMER TAB
                  Container(),
                  // SETTINGS TAB
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
