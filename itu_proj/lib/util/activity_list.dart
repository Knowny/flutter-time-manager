/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_tile.dart';

class ActivitiesList extends StatelessWidget {
  final List<dynamic> activities;
  final void Function(int) editActivity;
  final ToDoDatabase db;
  ActivitiesList(
    {super.key,
    required this.activities,
    required this.editActivity,
    required this.db,
    });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // displaying every activity 
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: GestureDetector(
              onTap: () {
                editActivity(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).cardColor, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(activities[index][0].toString()),
                  subtitle: Text(activities[index][1].toString(), style: TextStyle(color: db.getCategoryColor(activities[index][1].toString())),),
                  trailing: Text(formatDuration(activities[index][2], activities[index][3])),
                ),
              ),
            ),
          );
        },
    );
  }
    
  String formatDuration(DateTime end, Duration minutes) {
    // format duration to readable string
    DateTime start = end.subtract(minutes);
    
    String startTimeString = formatTime(start);
    String endTimeString = formatTime(end);

    return '$startTimeString - $endTimeString';
  }

  String formatTime(DateTime time) {
    // format datetime to readable string
    int hours = time.hour;
    int minutes = time.minute;
    int seconds = time.second;

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }
}
