// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final bool taskFavourited;

  Function(bool?)? onChanged;
  Function(BuildContext)? addToFavouritesFunction;
  Function(BuildContext)? editFunction;
  Function(BuildContext)? deleteFunction;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.taskFavourited,
    required this.onChanged,
    required this.addToFavouritesFunction,
    required this.editFunction,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: StretchMotion(),
          extentRatio: 0.25,
          children: [
            // * ADD TO FAVOURITES OPTION
            SlidableAction(
              onPressed: addToFavouritesFunction,
              icon: taskFavourited ? Icons.star : Icons.star_border,
              backgroundColor: Colors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
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
          decoration: BoxDecoration(
            border: taskFavourited
                ? Border.all(
                    width: 2, color: Colors.lightGreen)
                : null,
            borderRadius: BorderRadius.circular(12),
            color: taskCompleted
                ? Colors.grey.shade600
                : Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              // * CHECKBOX
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
              ),
              // * TASK NAME
              Container(
                width: 270,
                child: Text(
                  taskName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
              // * SLIDABLE ICON
              const Spacer(),
              const Icon(Icons.keyboard_arrow_left),
            ],
          ),
        ),
      ),
    );
  }
}
