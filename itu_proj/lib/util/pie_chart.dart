/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/pie_chart_details.dart';
import 'package:itu_proj/util/stats_segmented_button.dart';

class MyPieChart extends StatefulWidget {
  final ToDoDatabase db;
  final Selector selectorView;
  final void Function(int) onTouchedIndexChanged;
  
  MyPieChart({
    required this.db,
    required this.selectorView,
    required this.onTouchedIndexChanged,
    });

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  List<FlSpot> spots = [];
  List<Color> colors = [];
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
   
  }

  void loadData(){
    spots = [];
    colors = [];
    if (widget.selectorView == Selector.Today) {
      for (var index = 0; index < widget.db.categoryList.length; index++) {
        Color categoryColor = widget.db.categoryList[index][1];
        double categoryTime = widget.db.getTodayTotal(widget.db.categoryList[index][0]);

        spots.add(FlSpot(index.toDouble(), categoryTime));
        colors.add(categoryColor);
      }
    } else if (widget.selectorView == Selector.Week) {
      for (var index = 0; index < widget.db.categoryList.length; index++) {
        Color categoryColor = widget.db.categoryList[index][1];
        double categoryTime = widget.db.getThisWeekTotal(widget.db.categoryList[index][0]);

        spots.add(FlSpot(index.toDouble(), categoryTime));
        colors.add(categoryColor);
      }
    } else if (widget.selectorView == Selector.Month) {
      for (var index = 0; index < widget.db.categoryList.length; index++) {
        Color categoryColor = widget.db.categoryList[index][1];
        double categoryTime = widget.db.getThisMonthTotal(widget.db.categoryList[index][0]);

        spots.add(FlSpot(index.toDouble(), categoryTime));
        colors.add(categoryColor);
      }
    } else {
      // ALL
      for (var index = 0; index < widget.db.categoryList.length; index++) {
        Color categoryColor = widget.db.categoryList[index][1];
        double categoryTime = widget.db.getCategoryTime(widget.db.categoryList[index][0]);

        spots.add(FlSpot(index.toDouble(), categoryTime));
        colors.add(categoryColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
              border: Border.all(color: Colors.black, width: 15.0)
            ),
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (event is! FlTapUpEvent) {
                    return;
                  }

                  if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                  } else {
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  }
                  widget.onTouchedIndexChanged(touchedIndex);
                });
              },
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 100.0,
            sections: showingSections(spots, colors),
          ),
        ),
        Text(
          (touchedIndex == -1 ? "Total time" : widget.db.categoryList[touchedIndex][0]) + "\n" + 
          formatDuration(
            touchedIndex == -1 ? getTotalTimeSpent() : spots[touchedIndex].y,
          ),
          style: const TextStyle(fontSize: 20),

        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<FlSpot> spots, List<Color> colors) {
    if (spots.every((spot) => spot.y == 0)) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1.0,
          title: "",
          radius: 50.0,
          borderSide: const BorderSide(color: Colors.black, width: 0.5),
        ),
      ];
    }

    return List.generate(
      spots.length,
      (index) => PieChartSectionData(
        color: colors[index],
        value: spots[index].y,
        title: "",
        radius: 50.0,
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  String formatDuration(double minutes) {
    int totalSeconds = (minutes * 60).round();
    int hours = totalSeconds ~/ 3600;
    int minutesPart = (totalSeconds ~/ 60) % 60;
    int remainingSeconds = totalSeconds % 60;

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutesPart.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }

  double getTotalTimeSpent(){
    double totalTime = 0;
    for (var spot in spots) {
      totalTime += spot.y;
    }
    return totalTime;
  }
}
