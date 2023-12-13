/// file: timer_page.dart
/// author: xmager00
/// brief: timer tab
/// 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_pick.dart';
import 'package:itu_proj/util/timer_buttons.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
/// TickerProviderStateMixin for Animation controller vsync
class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
// refference the hive box
  final _myBox = Hive.box('mybox');
  //database stufferino
  ToDoDatabase db = ToDoDatabase();
  //animation controller
  late AnimationController controller;

  int minutes = 0;

  String categoryPickedName = "";

  bool isRunning = false;
  bool isIncremental = false;
  bool saveActivity = false;
  bool categoryPicked = false;


  //changes time text
  String get countText {
    Duration count = controller.duration! * controller.value + Duration(minutes: minutes);
    //return formatted text in tertiary operator
    return controller.isDismissed  
      ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
      : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  double progress = 1.0;
  Duration lastTimer = Duration.zero;

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
          }
          else if (isIncremental && controller.isCompleted){ //incremental ended cycle
            minutes ++;
            controller.value = 0;
            controller.duration = Duration(seconds: 60);
            controller.forward();
            isRunning = true; 
          }
          else if(isIncremental && controller.isDismissed){ //incremenatal stopped
            lastTimer = controller.duration! * progress + Duration(minutes: minutes);
            controller.duration = Duration.zero;
            isRunning = false;
            saveActivity = true;

          }
          //display full circle
          progress = 1.0;  

        });
        
        
      }
    });


    @override
    void dispose(){
      controller.dispose();
      super.dispose();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body:  Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Last setting: ${categoryPickedName} for ${lastTimer.inHours}:${(lastTimer.inMinutes % 60).toString().padLeft(2, '0')}:${(lastTimer.inSeconds % 60).toString().padLeft(2, '0')}',
                    //style: TextStyle(color: db.getCategoryColor("Red")),
                  ),
                ),
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
                          builder: (context) => Container(
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
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  

                ],
            ),
              ],
            ),
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if(!categoryPicked && controller.isDismissed){
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
                              if (isIncremental){
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
                        },
                      );
                      
                    }
                    
                    if (controller.isAnimating){
                      controller.stop();
                      setState(() {
                        isRunning = false;
                      });
                    }else{
                      if (categoryPicked && !isIncremental){
                        controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                      }else if (categoryPicked && isIncremental){
                        controller.forward(from: controller.value);
                      }
                      setState(() {
                        isRunning = true;
                      });
                    }
                  },
                  
                  child: RoundButton(
                    icon: isRunning ? Icons.pause : Icons.play_arrow,
                    )
                ),
                GestureDetector(
                  onTap:() {
                    controller.reset();
                    setState(() {
                      isRunning = false;
                      categoryPicked = false;
                    });
                  },
                  child: const RoundButton(
                    icon: Icons.stop
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed && !isIncremental){
                      controller.duration = lastTimer;
                      controller.reverse(
                        from: 1.0
                      );
                      setState(() {
                        isRunning = true;
                      });
                    }else if (controller.isDismissed && isIncremental){
                      controller.duration = lastTimer;
                      controller.forward();
                      setState(() {
                        categoryPicked = true;
                        isRunning = true;
                      });
                    }
                  },
                  child: const RoundButton(icon: Icons.restart_alt_rounded),
                ),
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

