// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? editFunction;
  Function(BuildContext)? deleteFunction;

  ToDoTile(
    {super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.editFunction,
    required this.deleteFunction,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // * EDIT OPTION
            SlidableAction(
              onPressed: editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(12),
              ),
            // * DELETE OPTION
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
              ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: taskCompleted 
          ? BoxDecoration(
            
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(12),
          )
          : BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ), 
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
              ),
              Container(
                width: 250,
                child: Text(
                  taskName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none
                  ),
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
