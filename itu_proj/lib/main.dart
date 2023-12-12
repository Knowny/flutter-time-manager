// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itu_proj/util/segmented_button.dart';
import 'package:itu_proj/pages/task_page.dart';
import 'package:itu_proj/pages/timer_page.dart';
import 'package:itu_proj/pages/stats_page.dart';
import 'package:itu_proj/pages/calendar_page.dart';
import 'package:itu_proj/pages/settings_page.dart';
import 'package:itu_proj/util/adapters.dart';

// import 'package:google_fonts/google_fonts.dart'; // for google fonts

void main() async {
  //init the hive db
  Hive.registerAdapter(MaterialColorAdapter());
  Hive.registerAdapter(DurationAdapter());
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          backgroundColor: Colors.grey[850],
          brightness: Brightness.dark,
        ),
        // textTheme: TextTheme(
          // //google fonts applicable
        // ),
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.checklist)),
                Tab(icon: Icon(Icons.timer)),
                Tab(icon: Icon(Icons.bar_chart)),
                Tab(icon: Icon(Icons.calendar_month)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            // title: const Text('Tabs Demo'),  // no title
            toolbarHeight: 0, // not text -> as much space for application as possible
          ),
          body: const TabBarView(
            children: [
              TaskPage(),
              TimerPage(),
              StatsPage(),
              CalendarPage(),
              SettingsPage(),
            ],
          ),
        ), 
      ),
    );
  }
}
