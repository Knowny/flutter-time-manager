import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  // refference the box
  final _myBox = Hive.box('mybox'); 

  // runs during the first ever app opening
  void createInitialData() {
    toDoList = [
      ["Create the database", false],
      ["Pass the ITU", false],
    ];
  }

  // load the data from db
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update the db
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }
}
