// author(s): xhusar11
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
  // * TASK LIST
  List toDoList = [];
  List activityList = [];
  List categoryList = [];
  List ongoingActivity = [];
  // * HABIT LIST
  List habitList = []; 

  // refference the box
  final _myBox = Hive.box('mybox'); 
  // runs during the first ever app opening
  void createInitialData() {
    // taskName, isCompleted, isFavourite
    toDoList = [
      ["Create the database", false, false],
      ["Pass the ITU", false, false],
    ];
    // todo better formatting
    // habitName, isCompleted, isHabitActive, timeSpent (sec), timeDuration (min), isFavourite, category
    habitList = [
      ["Test the timer", false, false, 0, 1, false],
      ["Test the 2nd timer", false, false, 0, 2, false],
      ["Code", false, false, 0, 30, false],
      ["Excercise", false, false, 0, 20, false],
      ["Meditate", false, false, 0, 10, false],
      ["Code in Flutter", false, false, 0, 5, false],
    ];
    //["name", "category", start_time, end_time, duration, goal]
    ongoingActivity = [];

    activityList = [
    // ["ACTIVITY_NAME", "CATEGORY", date(dateTime), timeSpent (seconds)]
      ["Learning Japanese", "School", DateTime.now(), const Duration(minutes: 30)],
      ["Push Ups", "Sport", DateTime.now(), const Duration(minutes: 10)],
      ["Watching Spidrman", "Free Time", DateTime.now(), const Duration(hours: 2)],
      ["Talking with Jessica", "Socialising", DateTime.now(), const Duration(minutes: 5)],
      ["Watching Witchur", "Free Time", DateTime.now(), const Duration(minutes: 30)],
      ["Talking with Jamal", "Socialising", DateTime.now(), const Duration(minutes: 10)],
      ["Watching Witchur", "Free Time", DateTime.now(), const Duration(minutes: 30)],
      ["Talking with Ferdinand", "Socialising", DateTime.now(), const Duration(minutes: 3)],
    ];
    
    categoryList = [
    // ["NAME","COLOR"]
      ["School", Colors.red],
      ["Sport", Colors.blue],
      ["Free Time", Colors.yellow],
      ["Socialising", Colors.orange]
    ];
  }

  // load the data from db
  void loadData() {
    toDoList = _myBox.get("TODOLIST");  // TODO RENAME TO TASKLIST
    habitList = _myBox.get("HABITLIST");
    activityList = _myBox.get("ACTIVITYLIST");
    categoryList = _myBox.get("CATEGORYLIST");
  }

  // update the db
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
    _myBox.put("HABITLIST", habitList);
    _myBox.put("ACTIVITYLIST", activityList);
    _myBox.put("CATEGORYLIST", categoryList);
  }

  // author: xjesko

  List<dynamic> getActivity(String name){
    for (var activity in activityList){
      if (activity[0] == name){
        return activity;
      }
    }
    return [];
  }

  Color getCategoryColor(String key){
    for (var category in categoryList){
      if (category[0] == key){
        return category[1];
      }
    }
    return Colors.grey;
  }

  double getTotalTimeSpent(){
    double totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      totalTime += durationToMinutes(activityList[index][3]);
    }
    return totalTime;
  }

  double getCategoryTime(String name){
    double totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name ){
      totalTime += durationToMinutes(activityList[index][3]);
      }
    }
    return totalTime;
  }

  List<dynamic> getActivitiesByDay(DateTime when) {
    return activityList.where((activity) {
      DateTime activityDate = activity[2]; // Assuming the date is stored at index 2
      return isSameDay(activityDate, when);
    }).toList();
  }

  double getTodayTotal(String name){
    double totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameDay(activityList[index][2], DateTime.now())){
        totalTime += durationToMinutes(activityList[index][3]);
      }
    }
    return totalTime;
  }

  double getThisWeekTotal(String name){
    double totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameWeek(activityList[index][2], DateTime.now())){
        totalTime += durationToMinutes(activityList[index][3]);
      }
    }
    return totalTime;
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    DateTime mondayDate1 = date1.subtract(Duration(days: date1.weekday - DateTime.monday));
    DateTime mondayDate2 = date2.subtract(Duration(days: date2.weekday - DateTime.monday));
    return mondayDate1.day == mondayDate2.day;
  }

  double getThisMonthTotal(String name){
    double totalTime = 0;
    for (var index = 0; index < activityList.length; index++) {
      if (activityList[index][1] == name && isSameMonth(activityList[index][2], DateTime.now())){
        totalTime += durationToMinutes(activityList[index][3]);
      }
    }
    return totalTime;
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  double durationToMinutes(Duration duration) {
    return duration.inSeconds / 60.0;
  }

}

