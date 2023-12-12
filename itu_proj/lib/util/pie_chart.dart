/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:itu_proj/data/database.dart';

class MyPieChart extends StatefulWidget {
  final ToDoDatabase db;

  MyPieChart(this.db);

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
    for (var category in widget.db.categoryList) {
      String categoryColor = category[1];
      int categoryTime = category[2];
      spots.add(FlSpot(spots.length.toDouble(), categoryTime.toDouble()));
      colors.add(widget.db.getCategoryColor(categoryColor) ?? Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (event is! FlTapUpEvent) {
                    // Ignore events other than tap up
                    return;
                  }

                  if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                    // No section was touched
                    touchedIndex = -1;
                  } else {
                    // A section in the PieChart was touched
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  }
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 120.0,
            sections: showingSections(spots, colors),
          ),
        ),
        Text(
          formatDuration(
            touchedIndex == -1 ? widget.db.getTotalTimeSpent() : widget.db.categoryList[touchedIndex][2],
          ),
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursString = hours.toString().padLeft(2, '0');
    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }

  List<PieChartSectionData> showingSections(List<FlSpot> spots, List<Color> colors) {
    return List.generate(
      spots.length,
      (index) => PieChartSectionData(
        color: colors[index],
        value: spots[index].y,
        title: "",
        radius: 60.0,
      ),
    );
  }
}
