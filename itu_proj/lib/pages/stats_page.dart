import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
// refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // 1st time ever opening app -> create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            'Stats Tab Content',
          ),
        ),
      ),
    );
  }
}