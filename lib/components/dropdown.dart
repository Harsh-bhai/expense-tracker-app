import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  // List of items

  // Selected item
  HiveListTileModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    return DropdownButton<HiveListTileModel>(
      isExpanded: true,
      underline: const SizedBox(),
      icon: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade500.withOpacity(0.3),
          ),
          child: const Icon(Icons.keyboard_arrow_down)),
      iconSize: 24,
      elevation: 16,
      borderRadius: BorderRadius.circular(10),
      value: _selectedCategory,
      hint: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.yellow.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.yellow,
              child: Icon(
                Icons.house,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            SizedBox(width: 8.0),
            Text("Rent"),
          ],
        ),
      ),
      onChanged: (HiveListTileModel? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      items: categoryNotifier.expenseCategories
          .map<DropdownMenuItem<HiveListTileModel>>((dynamic category) {
        return DropdownMenuItem<HiveListTileModel>(
          value: category,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: category.bgColor.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: category.bgColor,
                  child: Icon(
                    category.iconData,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(category.title),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
