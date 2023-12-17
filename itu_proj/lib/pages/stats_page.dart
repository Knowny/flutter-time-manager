/// author(s): xjesko01
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/pie_chart.dart';
import 'package:itu_proj/util/pie_chart_details.dart';
import 'package:itu_proj/util/stats_segmented_button.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Selector selectorView = Selector.Today;
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  int touchedIndex = -1;
  @override
  void initState() {
    if (_myBox.get("CATEGORYLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
          child: 
            MyPieChart(
              db: db, 
              selectorView: selectorView,
              onTouchedIndexChanged: (index) {
                setState(() {
                  touchedIndex = index;
                });
              },)
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5), 
          child: SizedBox(
            height: 200,
              child: PieChartDetails(
                key: ValueKey<int>(touchedIndex),
                filter: selectorView,
                db: db,
                categoryName: (touchedIndex == -1 ? "" : db.categoryList[touchedIndex][0]),
              ),
            )
          )
        ]
      ),
    ); 
  }

}