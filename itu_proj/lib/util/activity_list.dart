/// author(s): xjesko01
import 'package:flutter/material.dart';

class ActivitiesList extends StatelessWidget {
  final List<dynamic> activities;

  ActivitiesList(
    {super.key,
    required this.activities
    });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(activities[index][0].toString()),
                subtitle: Text(activities[index][1].toString()),
              ),
            ),
          );
        },
    );
  }
    
  String formatDuration(DateTime end, int seconds) {
    DateTime start = end.subtract(Duration(seconds: seconds));

    String startTimeString = _formatTime(start);
    String endTimeString = _formatTime(end);

    return '$startTimeString - $endTimeString';
  }

  String _formatTime(DateTime time) {
    int hours = time.hour;
    int minutes = time.minute;
    int seconds = time.second;

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }
}
