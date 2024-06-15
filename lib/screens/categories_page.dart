// ignore_for_file: non_constant_identifier_names

import 'package:expense_tracker/components/cateogory_box.dart';
import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final HiveListTileModel addCategory =  HiveListTileModel(
    title: 'Add Category',
    subtitle: 'create your category',
    icon: Icons.add,
    categoryName: "add",
    bgColor: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
    CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    categoryNotifier.getCategories();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    List<HiveListTileModel> ExpenseCateogry = [
       HiveListTileModel(
          title: 'Food',
          subtitle: 'Groceries, restaurants, etc.',
          icon: Icons.fastfood,
          categoryName: "food",
          bgColor: Colors.red),
      ...categoryNotifier.expenseCategories,
    ];
    List<HiveListTileModel> IncomeCateogry = [
       HiveListTileModel(
          title: 'Salary',
          subtitle: 'Monthly salary',
          icon: Icons.attach_money,
          categoryName: "salary",
          bgColor: Colors.green),
      ...categoryNotifier.incomeCategories,
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expense'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          categoryView(ExpenseCateogry),
          categoryView(IncomeCateogry),
        ],
      ),
    );
  }

  Padding categoryView(List<HiveListTileModel> categoryList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: categoryList.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // Add category box as the first item
          if (index == 0) {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => addCategoryDialog(context: context));
              },
              child: CategoryBox(category: addCategory),
            );
          } else {
            return CategoryBox(category: categoryList[index - 1]);
          }
        },
      ),
    );
  }

  AlertDialog addCategoryDialog({required BuildContext context}) {
  CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  IconData? selectedIcon;
  Color selectedColor = Colors.blue;

  return AlertDialog(
    title: const Text('Add Category'),
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: categoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              ListTile(
                title: const Text('Pick Icon'),
                trailing: selectedIcon != null
                    ? Icon(
                        selectedIcon,
                        size: 30,
                      )
                    : null,
                onTap: () async {
                  IconData? icon = await showIconPicker(context,
                      iconPackModes: <IconPack>[
                        IconPack.fontAwesomeIcons,
                        IconPack.material,
                      ],
                      showSearchBar: true,
                      closeChild: const Text("OK"));
                  if (icon != null) {
                    setState(() {
                      selectedIcon = icon;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Pick Color'),
                trailing: CircleAvatar(
                  backgroundColor: selectedColor,
                  radius: 12,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // Handle Add Category
          String categoryName = categoryNameController.text;
          String subtitle = subtitleController.text;
          IconData icon = selectedIcon ?? Icons.category;
          Color color = selectedColor;

          // Create a new HiveHiveListTileModel instance
          HiveListTileModel newCategory = HiveListTileModel(
            title: categoryName,
            subtitle: subtitle,
            icon: icon,
            bgColor: color,
          );

          // Add the new category to the notifier
          categoryNotifier.addCategory(newCategory);

          // Close the dialog
          Navigator.of(context).pop();
        },
        child: const Text('Add'),
      ),
    ],
  );
}
}
