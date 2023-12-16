import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTileLong extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  Function(BuildContext)? editFunction;
  Function(BuildContext)? deleteFunction;
  

  CategoryTileLong(
    {super.key, 
    required this.categoryName, 
    required this.categoryColor,
    required this.editFunction,
    required this.deleteFunction,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            // edit
            SlidableAction(
              onPressed: editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            // delete
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: categoryColor),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: categoryColor,
                child: Text(categoryName[0]),
              ),
              const SizedBox(width: 16.0),
              Container(
                width: 200,
                child: Text(
                  categoryName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(decoration: TextDecoration.none),
                ),
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_left),
            ],
          ),
        ),
      ),
    );
  }
}