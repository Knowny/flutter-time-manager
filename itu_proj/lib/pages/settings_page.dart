// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "Profile",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, indent: 20, endIndent: 20, ), 
                GestureDetector(
                  onTap:() {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CategoryDialog(
                          categoryList: db.categoryList,
                          onCategorySelected: (selectedCategory) {
                            null;
                          },
                        );
                      }
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15
                          ),
                        ),
                        Icon(Icons.chevron_right) 
                      ]
                    )
                  )
                ),
                
                GestureDetector(
                  onTap:() {
                    null;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Completed tasks",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15
                          ),
                        ),
                        Icon(Icons.chevron_right) 
                      ]
                    )
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "Data",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, indent: 20, endIndent: 20, ), 
              ],
            )
          )
        ]
      ),
    );
  }
}