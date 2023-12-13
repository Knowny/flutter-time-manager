import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

var colorMap = {
  "Orange" : Colors.orange,
  "Grey" : Colors.grey[850],
  "Red" : Colors.red,
  "Blue" : Colors.blue,
  "Yellow" : Colors.yellow
};

class ToDoDatabase {
  List toDoList = [];
  List activityList = [];
  List categoryList = [];

  // refference the box
  final _myBox = Hive.box('mybox'); 
  // runs during the first ever app opening
  void createInitialData() {
    toDoList = [
      ["Create the database", false],
      ["Pass the ITU", false],
    ];

    activityList = [
    // ["ACTIVITY_NAME", "CATEGORY", date(dateTime), timeSpent (seconds)]
      ["Learning Japanese", "School", DateTime.now(), 60*30],
      ["Push Ups", "Sport", DateTime.now(), 60*10],
      ["Watching Spidrman", "Free Time", DateTime.now(), 60*120],
      ["Talking with Jessica", "Socialising", DateTime.now(), 60*5],
    ];
    
    categoryList = [
    // ["NAME","COLOR"]
      ["School", "Red", 60*30],
      ["Sport", "Blue", 60*10],
      ["Free Time", "Yellow", 60*120],
      ["Socialising", "Orange", 60*5]
    ];
  }

  // load the data from db
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
    activityList = _myBox.get("ACTIVITYLIST");
    categoryList = _myBox.get("CATEGORYLIST");
  }

  // update the db
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
    _myBox.put("ACTIVITYLIST", activityList);
    _myBox.put("CATEGORYLIST", categoryList);
  }

  Color? getCategoryColor(String key){
    return colorMap[key];
  }

  num getTotalTimeSpent(){
    num timeSpent = 0;
    for (var category in categoryList) {
      timeSpent += category[2];
    }
    return timeSpent;
  }

}
