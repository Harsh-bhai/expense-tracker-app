import 'package:expense_tracker/components/cateogory_box.dart';
import 'package:expense_tracker/models/hive_listtile_model.dart';
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
  final HiveListTileModel addCategory = HiveListTileModel(
    title: 'Add Category',
    subtitle: 'create your category',
    icon: Icons.add,
    bgColor: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryNotifier>(context, listen: false).getCategories();
    });
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
          categoryView(categoryNotifier.expenseCategories,
               expense: true),
          categoryView(categoryNotifier.incomeCategories,
               income: true),
        ],
      ),
    );
  }

  Padding categoryView(List<dynamic> categoryList,
      {
      bool expense = false,
      bool income = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: categoryList.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // add category box
          if (index == 0) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => categoryDialog(
                    context: context,
                    addFunction: true,
                    expense: expense,
                    income: income,
                  ),
                );
              },
              child: CategoryBox(category: addCategory),
            );
            // default example category
          }  else {
            return InkWell(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => categoryDialog(
                    context: context,
                    category: categoryList[index - 1],
                    updateFunction: true,
                    expense: expense,
                    income: income,
                  ),
                );
              },
              child: CategoryBox(category: categoryList[index - 1]),
            );
          }
        },
      ),
    );
  }

  AlertDialog categoryDialog({
    required BuildContext context,
    HiveListTileModel? category,
    bool addFunction = false,
    bool updateFunction = false,
    bool expense = false,
    bool income = false,
  }) {
    CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    TextEditingController titleController =
        TextEditingController(text: category?.title ?? '');
    TextEditingController subtitleController =
        TextEditingController(text: category?.subtitle ?? '');
    IconData? selectedIcon = category?.iconData;
    Color selectedColor = category?.bgColor ?? Colors.blue;
 

    return AlertDialog(
      title: addFunction
          ? const Text('Add Category')
          : const Text('Update Category'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  enabled : addFunction ? true : false,
                  controller: titleController,
                  decoration:  const InputDecoration(
                    labelText:'Category Name (Unique)' ,
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
                    IconData? icon = await showIconPicker(
                      context,
                      iconPackModes: <IconPack>[
                        IconPack.fontAwesomeIcons,
                        IconPack.material,
                      ],
                      showSearchBar: true,
                      closeChild: const Text("OK"),
                    );
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
        !addFunction ? TextButton(
          onPressed: () {
            categoryNotifier.deleteCategory(category,expense: expense,income: income);
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ) : Container(),
        TextButton(
          onPressed: () {
            // Handle Add/Update Category
            String title = titleController.text;
            String subtitle = subtitleController.text;
            IconData icon = selectedIcon ?? Icons.category;
            Color color = selectedColor;

            // Create a new HiveListTileModel instance
            HiveListTileModel newCategory = HiveListTileModel(
              title: title,
              subtitle: subtitle,
              icon: icon,
              bgColor: color,
            );

            // Add the new category to the notifier
            if (addFunction) {
              categoryNotifier.addCategory(newCategory,
                  expense: expense, income: income);
            }
            if (updateFunction) {
              categoryNotifier.updateCategory(newCategory,
                  expense: expense, income: income);
            }

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: addFunction ? const Text('Add') : const Text('Update'),
        ),
      ],
    );
  }
}
