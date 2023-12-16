// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_settings.dart';
import '../util/category_tile_long.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
// refference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase(); //! RENAME?!?!

  @override
  void initState() {
    // 1st time ever opening app -> create default data
    // ! REWRITE !
    if (_myBox.get("CATEGORYLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }
    // ! REWRITE !
    super.initState();
  }

  final _categoryNameController = TextEditingController();

  // !CHANGE TO COLORS
  final _categoryColorController = TextEditingController();

  // create new category
  void createNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return CategoryDialogBox(
          categoryNameController: _categoryNameController,
          categoryColorController: _categoryColorController,

          onSave: saveNewCategory,

          onCancel: () => Navigator.of(context).pop(),
          // categoryList: categoryList,
          // onCategorySelected: onCategorySelected
          onColorChange: (){
            
          },
        );
      },
    );
  }

  // save new category
  void saveNewCategory() {
    String newCategoryName = _categoryNameController.text;
    // !CHANGE TO COLOR
    String newCategoryColor = _categoryColorController.text;
    if ((newCategoryName.isNotEmpty) && (newCategoryColor.isNotEmpty)) {
      setState(() {
        db.categoryList
            .add([_categoryNameController.text, _categoryColorController.text]);
        _categoryNameController.clear();
        _categoryColorController.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
      // todo category added snackbar
    } else if (newCategoryColor.isNotEmpty) {
      // showEmptyCategoryNameDialog(context);
    } else {
      // showEmptyCategoryColorDialog(context);
    }
  }

  // edit category
  void editCategory(int index) {
    String currentCategoryName = db.categoryList[index][0];
    _categoryNameController.text = currentCategoryName;

    // !change to colors
    String currentCategoryColor = db.categoryList[index][0];
    _categoryNameController.text = currentCategoryColor;

    showDialog(
        context: context,
        builder: (context) {
          return CategoryDialogBox(
            categoryNameController: _categoryNameController,
            categoryColorController: _categoryColorController,
            onSave: () {
              saveExistingCategory(index, _categoryNameController.text,
                  _categoryColorController.text);
            },
            onCancel: () {
              Navigator.of(context).pop();
              _categoryNameController.clear();
              _categoryColorController.clear();
            },
            onColorChange: (){

            },
          );
        });
  }

  // save existing category
  void saveExistingCategory(int index, String newName, String newColor) {
    if (newName.isNotEmpty && newColor.isNotEmpty) {
      setState(() {
        db.categoryList[index][0] = newName;
        db.categoryList[index][1] = newColor;
        _categoryNameController.clear();
        _categoryColorController.clear();
      });
      Navigator.of(context).pop;
      db.updateDataBase();
      // categoryEditedSnackBar(context);
    } else if (newColor.isNotEmpty) {
      // showEmptyCategoryNameDialog(context);
    } else {
      // showEmptyCategoryColorDialog(context);
    }
  }

  // delete category
  void deleteCategory(int index) {
    setState(() {
      db.categoryList.removeAt(index);
    });
    db.updateDataBase();
    // todo categoryDeletedSnackBar(context);
  }

  // ! rebuild whole page?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: db.categoryList.length,
        itemBuilder: (context, index) {
          //todo last tile bottom padding?
          return CategoryTileLong(
            categoryName: db.categoryList[index][0],
            categoryColor: db.categoryList[index][1],
            editFunction: (context) => editCategory(index),
            deleteFunction: (context) => deleteCategory(index),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewCategory, 
        child: const Icon(Icons.add),
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
//               child: Text(
//                 "Profile",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//               indent: 20,
//               endIndent: 20,
//             ),
//             GestureDetector(
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return CategoryDialogBox(
//                           categoryList: db.categoryList,
//                           onCategorySelected: (selectedCategory) {
//                             null;
//                           },
//                         );
//                       });
//                 },
//                 child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Categories",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(fontSize: 15),
//                           ),
//                           Icon(Icons.chevron_right)
//                         ]))),
//             GestureDetector(
//                 onTap: () {
//                   null;
//                 },
//                 child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Completed tasks",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(fontSize: 15),
//                           ),
//                           Icon(Icons.chevron_right)
//                         ]))),
//             const Padding(
//               padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
//               child: Text(
//                 "Data",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//               indent: 20,
//               endIndent: 20,
//             ),
//           ],
//         ))
//       ]),
//     );
//   }
// }
