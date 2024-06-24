// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';

class MyDropDown extends StatefulWidget {
  final bool isDebit;
  SmsMessage message;
  MyDropDown({super.key, required this.isDebit, required this.message});

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
    String currentCategoryName = categoryNotifier.getCategoryNameById(widget.message.id ?? 0);
    HiveListTileModel? currentCategory = categoryNotifier.findCategory(currentCategoryName,isDebit:widget.isDebit );
    return widget.isDebit
        ?
        // expense category
        DropdownButton<HiveListTileModel>(
            isExpanded: true,
            underline: const SizedBox(),
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: currentCategory?.bgColor?.withOpacity(0.3),
              ),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
            iconSize: 24,
            elevation: 16,
            borderRadius: BorderRadius.circular(10),
            value: _selectedCategory,
            hint: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: currentCategory?.bgColor?.withOpacity(0.3),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: currentCategory?.bgColor,
                    child: Icon(currentCategory?.iconData ?? Icons.question_mark, size: 20.0,),
                  ),
                  const SizedBox(width: 8.0),
                  Text(currentCategory?.title ?? "Select Category"),
                ],
              ),
            ),
            onChanged: (HiveListTileModel? newValue) {
              setState(() {
                _selectedCategory = newValue;
                categoryNotifier.saveCategoryToMap(widget.message.id ?? 1, newValue?.title ?? "");
              });
            },
            // dropdown items
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
          )
        :
        // income category
        DropdownButton<HiveListTileModel>(
            isExpanded: true,
            underline: const SizedBox(),
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: currentCategory?.bgColor?.withOpacity(0.3),
              ),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
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
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: currentCategory?.bgColor,
                    child: Icon(currentCategory?.iconData ?? Icons.question_mark, size: 20.0,),
                  ),
                  const SizedBox(width: 8.0),
                  Text(currentCategory?.title ?? "Select Category"),
                ],
              ),
            ),
            onChanged: (HiveListTileModel? newValue) {
              setState(() {
                _selectedCategory = newValue;
                categoryNotifier.saveCategoryToMap(widget.message.id ?? 1, newValue?.title ?? "");

              });
            },
            items: categoryNotifier.incomeCategories
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


