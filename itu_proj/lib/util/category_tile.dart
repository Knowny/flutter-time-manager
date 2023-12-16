import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const CategoryTile(
    {super.key, 
    required this.categoryName, 
    required this.categoryColor
    });

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding:  EdgeInsets.all(0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: categoryColor,
            child: Text(
              '${categoryName[0]}',
              //style: TextStyle(color: categoryColor),
              
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              '${categoryName}'
            )
          )
          
        ],
      ),
      );
  }}