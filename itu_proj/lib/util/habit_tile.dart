// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  Function(bool?)? onChanged; // if started/paused/resumed ... how to stop entirely?
  Function(BuildContext)? deleteFunction; // delete the habit
  // edit the habit function?

  HabitTile(
    {super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.deleteFunction,
    // edithabit?
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // timer
                  CircularPercentIndicator(
                    radius: 40,
                    // percent: 0.7,
                  ),

                  const SizedBox(width: 15), 

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // habit name
                      Text(
                        habitName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: habitCompleted
                              ? TextDecoration.lineThrough //if completed
                              : TextDecoration.none //if not completed
                        ),
                      ),

                      // const sized box???

                      // habit progress
                      Text(
                        '2:00 / 10 = 20%',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_back),
            ],
          ),
        ),
      ),
    );
  }

}