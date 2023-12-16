import 'package:flutter/material.dart';
import 'package:itu_proj/util/my_button.dart';

class CategoryDialogBox extends StatefulWidget {
  final categoryNameController;
  final categoryColorController;
  VoidCallback onSave;
  VoidCallback onCancel;

  CategoryDialogBox({
    Key? key, // Added Key parameter
    required this.categoryNameController,
    required this.categoryColorController,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key); // Use super(key: key)

  @override
  _CategoryDialogBoxState createState() => _CategoryDialogBoxState();
}

class _CategoryDialogBoxState extends State<CategoryDialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[850],
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Category name:'),
            TextField(
              controller: widget.categoryNameController, // Use widget. prefix
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(),
                hintText: 'Category name',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButtonPrimary(
                  text: 'Save',
                  onPressed: widget.onSave, // Use widget. prefix
                ),
                const SizedBox(width: 8,),
                MyButtonSecondary(
                  text: 'Cancel',
                  onPressed: widget.onCancel, // Use widget. prefix
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


  // void createNewCategory(BuildContext context) {
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: const Text("unfortunatelly"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

  //   AlertDialog alert = AlertDialog(
  //     title: Text("You fool!"),
  //     content: Text("you are trying to create a category"),
  //     actions: [
  //       cancelButton,
  //     ],
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return alert;
  //       });
  // }

  // void editCategory(BuildContext context) {
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: const Text("unfortunatelly"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

    
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return alert;
  //       });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //     surfaceTintColor: Colors.black,
  //     backgroundColor: Colors.grey[850],
  //     content: SizedBox(
  //         width: double.maxFinite,
  //         child: GridView.builder(
  //           itemCount: categoryList.length,
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //           ),
  //           itemBuilder: (context, index) {
  //             return GestureDetector(
  //               onLongPress: () {
  //                 onCategorySelected(categoryList[index][0]);
  //                 editCategory(context);
  //               },
  //               child: CategoryTile(
  //                 categoryName: categoryList[index][0],
  //                 categoryColor: categoryList[index][1],
  //               ),
  //             );
  //           },
  //         )),
  //   );
  // }
