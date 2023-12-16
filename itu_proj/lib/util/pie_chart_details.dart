/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/stats_segmented_button.dart';

class PieChartDetails extends StatefulWidget {
  final Selector filter;
  final ToDoDatabase db;
  final String categoryName;

  PieChartDetails({
    required this.filter,
    required this.db,
    required this.categoryName,
    Key? key, 
  }) : super(key: key);

  @override
  _PieChartDetailsState createState() => _PieChartDetailsState();
}


class _PieChartDetailsState extends State<PieChartDetails> {

  @override
  Widget build(BuildContext context) {
    List<dynamic> activities = widget.db.getThisActivitiesByFilter(widget.filter.name, widget.categoryName);
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: (widget.categoryName == "") ? widget.db.categoryList.length : activities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ), 
                child: (widget.categoryName == "") 
                  ? ListTile( //list categories
                      title: Text(widget.db.categoryList[index][0].toString(), style: TextStyle(color: widget.db.getCategoryColor(widget.db.categoryList[index][0])),),
                      trailing: Text(formatDuration(widget.db.getCategoryDuration(widget.db.categoryList[index][0]))),
                      )
                  : ListTile( // list activities
                    title: Text(activities[index][0].toString(), style: TextStyle(color: widget.db.getCategoryColor(activities[index][1])),),
                    trailing: Text(formatDuration(widget.db.getCategoryDuration(widget.db.categoryList[index][0]))),
                  ),
              ),
          );
        },
    );
  }

  String formatDuration(Duration totalDuration) {
    int hours = totalDuration.inHours;
    int minutes = (totalDuration.inMinutes % 60);
    int seconds = (totalDuration.inSeconds % 60);

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = seconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }
}
