/// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/todo_dialog_box.dart';
import 'package:itu_proj/util/segmented_button.dart';
import '../util/todo_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Selector selectorView = Selector.Tasks;
  
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

  // * TAPPED CHECKBOX
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // * SAVE TASK
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // * CREATE TASK
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask, // TODO CHECK NON EMPTY AND LENGTH OF THE TEXT
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // * DELETE TASK
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

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
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTask(index),
                  );
                },
              )
              :
              // * BUILD LIST - HABITS
              ListView.builder(
                itemCount: db.toDoList.length - 1,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: db.toDoList[index + 1][0],
                    taskCompleted: db.toDoList[index + 1][1],
                    onChanged: (value) => checkBoxChanged(value, index + 1),
                    deleteFunction: (context) => deleteTask(index + 1),
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
        child: Icon(Icons.add),
      )
      :
      // * FLOATING ACTION BUTTON - HABITS
      FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.remove),
      ),
    );
  }
}
