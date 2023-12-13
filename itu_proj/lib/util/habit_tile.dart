// author(s): xhusar11

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final bool habitActive;
  final int timeSpent;
  final int timeDuration;

  // Function(bool?)? onTap; // if started/paused/resumed ... how to stop entirely?
  final VoidCallback onTap;
  Function(BuildContext)? editFunction;
  Function(BuildContext)? deleteFunction;

  HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.habitActive,
    required this.timeSpent,
    required this.timeDuration,
    required this.onTap,
    required this.editFunction,
    required this.deleteFunction,
  });

  // format seconds into hour:min:sec
  String formatTime(int totalSeconds) {
    String seconds = (totalSeconds % 60).toString();
    String minutes = (totalSeconds / 60)
        .toStringAsFixed(5); // 5 decimal places (for calculation and rounding)

    // if seconds are 1 digit number, add a 0 in front of it
    if (seconds.length == 1) {
      seconds = '0' + seconds;
    }

    // if minutes are 1 digit number
    if (minutes[1] == '.') {
      minutes =
          minutes.substring(0, 1); // get the numbers before the decimal place
    }

    // todo -> do a simmilar thing for hours

    return minutes + ':' + seconds;
  }

  // calculate the percentage of the progress bar
  double percentCompleted() {
    return timeSpent / (timeDuration * 60);
  }

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
          decoration: habitCompleted
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
              // * ROUNDED TIMER + PLAY/STOP BUTTON
              GestureDetector(
                onTap: onTap,
                child: SizedBox(
                  height: 64,
                  width: 64,
                  child: Stack(
                    children: [
                      CircularPercentIndicator(
                        radius: 32,
                        percent:
                            percentCompleted() < 1 ? percentCompleted() : 1,  // cap the percent to 1
                        progressColor: Colors
                            .orange, //todo - suggestion -> the progress bar color should be the color of the category
                      ),
                      Center(
                        child: Icon(
                          habitActive ? Icons.pause : Icons.play_arrow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // * TASK NAME + PERCENTAGE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * HABIT NAME
                  SizedBox(
                    width: 200,
                    child: Text(
                      habitName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: habitCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // * PROGRESS TEXT
                  Text(
                    // TODO
                    formatTime(timeSpent) +
                        ' / ' +
                        timeDuration.toString() +
                        ' = ' +
                        (percentCompleted() * 100).toStringAsFixed(0) +
                        '%',
                    // '2:00 / 10 = 20%',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
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
