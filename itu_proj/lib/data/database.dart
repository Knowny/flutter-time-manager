import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

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
      ["Watching Witchur", "Free Time", DateTime.now(), 60*30],
      ["Talking with Jamal", "Socialising", DateTime.now(), 60*10],
      ["Watching Witchur", "Free Time", DateTime.now(), 60*30],
      ["Talking with Ferdinand", "Socialising", DateTime.now(), 60*3],
    ];
    
    categoryList = [
    // ["NAME","COLOR"]
      ["School", Colors.red, 60*30],
      ["Sport", Colors.blue, 60*10],
      ["Free Time", Colors.yellow, 60*120],
      ["Socialising", Colors.orange, 60*5]
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

  Color getCategoryColor(String key){
    for (var category in categoryList){
      if (category[0] == key){
        return category[1];
      }
    }
    return Colors.grey;
  }

  num getTotalTimeSpent(){
    num timeSpent = 0;
    for (var category in categoryList) {
      timeSpent += category[2];
    }
    return timeSpent;
  }

  List<dynamic> getActivitiesByDay(DateTime when) {
    return activityList.where((activity) {
      DateTime activityDate = activity[2]; // Assuming the date is stored at index 2
      return isSameDay(activityDate, when);
    }).toList();
  }

  num getTodayTotal(String name){
    num totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameDay(activityList[index][2], DateTime.now())){
        totalTime += activityList[index][3];
      }
    }
    return totalTime;
  }

  num getThisWeekTotal(String name){
    num totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameWeek(activityList[index][2], DateTime.now())){
        totalTime += activityList[index][3];
      }
    }
    return totalTime;
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    DateTime mondayDate1 = date1.subtract(Duration(days: date1.weekday - DateTime.monday));
    DateTime mondayDate2 = date2.subtract(Duration(days: date2.weekday - DateTime.monday));
    return mondayDate1.day == mondayDate2.day;
  }

  num getThisMonthTotal(String name){
    num totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameMonth(activityList[index][2], DateTime.now())){
        totalTime += activityList[index][3];
      }
    }
    return totalTime;
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

}
