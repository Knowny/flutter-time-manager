///---------------------------
/// file: timer_page.dart
/// author: xmager00
/// brief: timer tab
///---------------------------

///--------------------------------------------------------------
///                          PACKAGES
///--------------------------------------------------------------
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_pick.dart';
import 'package:itu_proj/util/timer_buttons.dart';
///--------------------------------------------------------------
///                     CLASS TIMER PAGE
///--------------------------------------------------------------
class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
/// TickerProviderStateMixin for Animation controller vsync
class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  ///--------------------------------------------------------------
  ///                          db
  ///--------------------------------------------------------------
  // refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  ///--------------------------------------------------------------
  ///                     VARIABLES
  ///--------------------------------------------------------------
  late AnimationController controller;
  int minutes = 0;
  String categoryPickedName = "";

  bool isRunning = false;
  bool isIncremental = false;
  bool categoryPicked = false;
  bool activitySaved = false;
  double progress = 1.0;
  Duration lastTimer = Duration.zero;


  ///--------------------------------------------------------------
  ///                     TIMER TEXT
  ///--------------------------------------------------------------
  String get countText {
    Duration count = controller.duration! * controller.value + Duration(minutes: minutes);
    //return formatted text in tertiary operator
    return controller.isDismissed  
      ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
      : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  ///--------------------------------------------------------------
  ///                     init
  ///--------------------------------------------------------------
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

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 0));
    ///--------------------------------------------------------------
    ///                   CONTROLLER LISTENER
    ///--------------------------------------------------------------
    controller.addListener(() {
      if (controller.isAnimating){
        setState(() {
          progress = controller.value;
        });
      }else{
        setState(() {
          if(controller.isDismissed && !isIncremental){ //decremental ended / stopped
            //save last duration for repeat
            lastTimer = controller.duration!;
            //zero out duration
            controller.duration = Duration.zero;
            categoryPicked = false;
            isRunning = false;
            activityCreate();
          }
          else if (isIncremental && controller.isCompleted){ //incremental ended cycle
            minutes ++;
            controller.value = 0;
            controller.duration = const Duration(seconds: 60);
            controller.forward();
            isRunning = true; 
          }
          else if(isIncremental && controller.isDismissed){ //incremenatal stopped
            lastTimer = controller.duration! * progress + Duration(minutes: minutes);
            controller.duration = Duration.zero;
            isRunning = false;

          }
          //display full circle
          progress = 1.0;  
        });
      }
    });
  }

  void activityCreate(){
    final snackBar = SnackBar(
      content: Text('Activity saved', 
        style: TextStyle(color: Colors.grey.shade900.withOpacity(1.0)),
      ),
      backgroundColor: Colors.grey.withOpacity(0.8),
    );

    if(categoryPickedName != "" && lastTimer != Duration.zero){
      // db.activityList.add(["Unnamed activity", categoryPickedName, DateTime.now(), lastTimer]);
      // db.updateDataBase();
      setState(() {
        activitySaved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar
      );
    }
  }
  ///--------------------------------------------------------------
  ///                     BUILD
  ///--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body:  Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ///--------------------------------------------------------------
                ///                     TOP TEXT
                ///--------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    "",
                  ),
                ),
              ///--------------------------------------------------------------
              ///                     TIMER CIRCLE
              ///--------------------------------------------------------------
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[800],
                      value: progress,
                      strokeWidth: 5,
                      
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //prevents user from picking time while timer is running
                      if (controller.isDismissed && !isIncremental){
                        showModalBottomSheet(
                          context: context, 
                          builder: (context) => SizedBox(
                            height: 300,
                            child: CupertinoTimerPicker(
                              //initialTimerDuration: controller.duration!,
                              onTimerDurationChanged: (time) {
                                setState(() {
                                  controller.duration = time;
                                });
                              },
                            ),
                          ),);
                      }
                    },
                    child: AnimatedBuilder(
                      animation: controller, 
                      builder: (context, child) => Text(
                        //from String get countText
                        countText,
                        style: const TextStyle(
                          fontSize: 60,
                        ),
                      ),
                    ),
                  ),
                ],
            ),
              ],
            ),
            
          ),
          ///--------------------------------------------------------------
          ///                     BUTTONS
          ///--------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///--------------------------------------------------------------
                ///                    PLAY/PAUSE
                ///--------------------------------------------------------------
                GestureDetector(
                  onTap: () {
                    if(!isIncremental && controller.duration == Duration.zero){ //decrementing from 0
                      showDialog(
                        context: context, 
                        builder: (context){
                        return AlertDialog(
                            content: const Text("Timer has to be set to a non zero value in this mode"),
                            actions: [ TextButton(
                              child: const Text("OK"),
                                onPressed:  () {
                                  Navigator.pop(context);
                                }
                              )
                            ],
                          );
                        }
                      );
                    }else{
                      if(!categoryPicked && controller.isDismissed){ //category pick dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CategoryBox(
                            categoryList: db.categoryList,
                            onCategorySelected: (selectedCategory) {
                            // Handle the selected category in your main page
                              setState(() {
                                categoryPickedName = selectedCategory;
                                categoryPicked = true;
                              });
                              if (isIncremental){ //start timer after category is picked
                                setState(() {
                                  controller.value = 0;
                                  controller.duration = const Duration(seconds: 60);
                                });
                                controller.forward();
                              }else{
                                controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                              }
                              setState(() {
                                isRunning = true;
                              });
                            },
                          );
                        },//builder
                      );//end of category dialog
                    }//if-else   
                    
                    
                    if (controller.isAnimating){ //pause
                      controller.stop();
                      setState(() {
                        isRunning = false;
                      });
                    }else{
                      if (categoryPicked && !isIncremental){ //resume decrement
                        controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                      }else if (categoryPicked && isIncremental){ //resume increment
                        controller.forward(from: controller.value);
                      }
                      setState(() {
                        isRunning = true;
                      });
                    } //if-else 
                  
                    }//if
                  }, //onTap
                  
                  child: RoundButton(
                    icon: isRunning ? Icons.pause : Icons.play_arrow,
                    )
                ),
                ///--------------------------------------------------------------
                ///                     STOP
                ///--------------------------------------------------------------
                GestureDetector(
                  onTap:() {
                    controller.reset();
                    setState(() {
                      isRunning = false;
                      categoryPicked = false;
                      activityCreate();
                    });
                  },
                  child: const RoundButton(
                    icon: Icons.stop
                  ),
                ),
                ///--------------------------------------------------------------
                ///                     RESET
                ///--------------------------------------------------------------
                GestureDetector(
                  onTap: () {
                    if(categoryPickedName != "" && lastTimer != Duration.zero){
                        if (controller.isDismissed && !isIncremental){
                        controller.duration = lastTimer;
                        controller.reverse(
                          from: 1.0
                        );
                        setState(() {
                          categoryPicked = true;
                          isRunning = true;
                        });
                      }else if (controller.isDismissed && isIncremental){
                        controller.duration = const Duration(seconds: 60);
                        controller.forward();
                        setState(() {
                          categoryPicked = true;
                          isRunning = true;
                        });
                      }
                    }
                    
                  },
                  child: const RoundButton(icon: Icons.restart_alt_rounded),
                ),
                ///--------------------------------------------------------------
                ///                     TIMER MODE
                ///--------------------------------------------------------------
                GestureDetector(
                  onTap: () {
                    if(isIncremental){
                      setState(() {
                        isIncremental = false;
                        minutes = 0;
                      });
                      
                    }else{
                     setState(() {
                        isIncremental = true;
                      });
                    }
                  },
                  child: RoundButton(icon: isIncremental ? Icons.timer : Icons.timelapse),
                )
              ],
            ),
          )
        ],
      )
    );
  }


}

