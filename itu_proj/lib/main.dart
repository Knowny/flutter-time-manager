import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itu_proj/pages/task_page.dart';

void main() async {
  //init the hive db
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // DEFINE PRIMARY COLORS
    Color myPrimaryColor = const Color.fromARGB(255, 208, 188, 255);
    Color myBackgroundColor = const Color.fromARGB(255, 20, 18, 24);
    Color myTextColor = const Color.fromARGB(255, 230, 224, 233);

    // CREATE A MATERIAL COLORS FROM THE PRIMARY COLORS
    MaterialColor myPrimarySwatch = MaterialColor(
      myPrimaryColor.value, // Use the primary color's value
      <int, Color>{
        50: myPrimaryColor.withOpacity(0.1),
        100: myPrimaryColor.withOpacity(0.2),
        200: myPrimaryColor.withOpacity(0.3),
        300: myPrimaryColor.withOpacity(0.4),
        400: myPrimaryColor.withOpacity(0.5),
        500: myPrimaryColor, // The primary color
        600: myPrimaryColor.withOpacity(0.6),
        700: myPrimaryColor.withOpacity(0.7),
        800: myPrimaryColor.withOpacity(0.8),
        900: myPrimaryColor.withOpacity(0.9),
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskPage(),
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: TextStyle(color: myTextColor),
          bodyLarge: TextStyle(color: myTextColor), 
        ),
        primarySwatch: myPrimarySwatch,
        
        backgroundColor: myBackgroundColor,
      ),
    );
  }
}
