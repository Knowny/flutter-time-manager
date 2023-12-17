// author(s): xhusar11
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_proj/data/database.dart';
import 'package:itu_proj/util/category_settings.dart';
import '../util/category_tile_long.dart';
import 'package:itu_proj/util/category_dialogs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late Box _myBox;
  // !REMANE
  late ToDoDatabase db;

  @override
  void initState() {
    // refference the hive box
    // final _myBox = Hive.box('mybox');
    // ToDoDatabase db = ToDoDatabase();

    // 1st time ever opening app -> create default data
    // if (_myBox.get("CATEGORYLIST") == null) {
    //   db.createInitialData();
    // } else {
    //   // data already exists
    //   db.loadData();
    // }
    // ! REWRITE !
    super.initState();
    _initHive();
  }

  // Asynchronous Initialization
  Future<void> _initHive () async {
    _myBox = Hive.box('mybox');
    db = ToDoDatabase();

    // 1st time ever opening app -> create initial data
    if (_myBox.get("CATEGORYLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  // https://stackoverflow.com/questions/73234954/how-i-can-convert-a-color-into-materialcolor-so-i-can-have-a-limited-pallete-of
  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }

  final _categoryNameController = TextEditingController();

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
        );
      },
    );
  }

  // save new category
  void saveNewCategory() {
    String newCategoryName = _categoryNameController.text;
    String colorString = _categoryColorController.text;

    // Color newCategoryColor;

    String newColorString;

    if (colorString.isNotEmpty) {
      newColorString = colorString;
          // Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } else {
      newColorString = "#f44336"; //red color
      // newCategoryColor = const Color(0xfff44336);
    }

    // newCategoryColor = getMaterialColor(newCategoryColor);

    if (newCategoryName.isNotEmpty) {
      setState(() {
        db.categoryList.add([newCategoryName, newColorString]);
        _categoryNameController.clear();
        _categoryColorController.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
      categoryAddedSnackBar(context);
    } else {
      showEmptyCategoryNameDialog(context);
    }
  }

  // edit category
  void editCategory(int index) {
    String currentCategoryName = db.categoryList[index][0];
    _categoryNameController.text = currentCategoryName;

    // Color currentCategoryColor = db.categoryList[index][1];
    String currentCategoryColorString = db.categoryList[index][1];
    _categoryColorController.text = currentCategoryColorString;

    showDialog(
        context: context,
        builder: (context) {
          return CategoryDialogBox(
            categoryNameController: _categoryNameController,
            categoryColorController: _categoryColorController,
            onSave: () {
              saveExistingCategory(index, _categoryNameController.text,
                  _categoryColorController.text);
              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(context).pop();
              _categoryNameController.clear();
              _categoryColorController.clear();
            },
          );
        });
  }

  // save existing category
  void saveExistingCategory(int index, String newName, String colorString) {
    if (newName.isNotEmpty) {
      // if (newName.isNotEmpty && colorString.isNotEmpty) {
      setState(() {
        db.categoryList[index][0] = newName;
        
        // Color newCategoryColor =
        //     Color(int.parse(colorString.replaceFirst('#', '0xFF')));
        // newCategoryColor = getMaterialColor(newCategoryColor);

        db.categoryList[index][1] = colorString;
        _categoryNameController.clear();
        _categoryColorController.clear();
      });
      db.updateDataBase();
      categoryEditedSnackBar(context);
    } else {
      showEmptyCategoryNameDialog(context);
    }
  }

  // delete category
  void deleteCategory(int index) {
    setState(() {
      db.categoryList.removeAt(index);
    });
    db.updateDataBase();
    categoryDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: db.categoryList.length,
          itemBuilder: (context, index) {
            bool isLastTile = index == db.categoryList.length - 1;
            bool isFirstTile = index == 0;
            return Padding(
              padding: EdgeInsets.only(top: isFirstTile ? 32.0 :0, bottom: isLastTile ? 64.0 : 0.0),
              child: CategoryTileLong(
                categoryName: db.categoryList[index][0],
                categoryColor: db.getCategoryColor(db.categoryList[index][0]),
                editFunction: (context) => editCategory(index),
                deleteFunction: (context) => deleteCategory(index),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
