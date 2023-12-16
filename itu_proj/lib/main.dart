/// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:itu_proj/util/adapters.dart';
import 'package:itu_proj/pages/todo_page.dart';
import 'package:itu_proj/pages/timer_page.dart';
import 'package:itu_proj/pages/stats_page.dart';
import 'package:itu_proj/pages/calendar_page.dart';
import 'package:itu_proj/pages/settings_page.dart';


void main() async {
  AwesomeNotifications().initialize(
    // default icon
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests'),
    ],
    debug: true,
  );

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
                Tab(icon: Icon(Icons.category)),
              ],
            ),
            toolbarHeight: 0,
          ),
          body: const TabBarView(
            children: [
              TodoPage(),
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
