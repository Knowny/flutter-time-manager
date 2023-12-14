import 'package:flutter/material.dart';
import '../util/category_tile.dart';

class CategoryBox extends StatelessWidget {
  final List<dynamic> categoryList;
  final Function(String) onCategorySelected;

  const CategoryBox({
    super.key, 
    required this.categoryList,
    required this.onCategorySelected
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.grey[850],
      content: SizedBox(
          width: double.maxFinite,
          child :
            GridView.builder(
              itemCount: categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return 
                GestureDetector(
                  onTap: (){
                    onCategorySelected(categoryList[index][0]);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: CategoryTile(
                    categoryName: categoryList[index][0], 
                    categoryColor: categoryList[index][1],
                  ),
                );
              },
          )
        ),
      ); 
  }
  

}