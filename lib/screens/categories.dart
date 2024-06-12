import 'package:expense_tracker/components/cateogory_box.dart';
import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CategoryPage extends StatelessWidget {
  final ListTileModel addCategory = const ListTileModel(
    title: 'Add Category',
    subtitle: 'create your category',
    icon: Icons.add,
    categoryName: "add",
    bgColor: Colors.grey,
  );

  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    CateogryNotifier categoryNotifier = Provider.of<CateogryNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Grid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categoryNotifier.categories.length + 1,
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
                      builder: (context) =>
                          addCategoryDialog(context: context));
                },
                child: CategoryBox(category: addCategory),
              );
            } else {
              return CategoryBox(
                  category: categoryNotifier.categories[index - 1]);
            }
          },
        ),
      ),
    );
  }

  AlertDialog addCategoryDialog({required BuildContext context}) {
    TextEditingController categoryNameController = TextEditingController();
    TextEditingController subtitleController = TextEditingController();
    IconData? selectedIcon;
    Color selectedColor = Colors.blue;

    return AlertDialog(
    title: const Text('Add Category'),
    content: SingleChildScrollView(
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
              labelText: 'Subtitle',
            ),
          ),
          ListTile(
            title: const Text('Pick Icon'),
            trailing: selectedIcon != null ? Icon(selectedIcon) : null,
            onTap: () async {
              IconData? icon = await showIconPicker(
                context,
                iconPackModes: <IconPack>[IconPack.material, IconPack.cupertino],
                showSearchBar: true,
              );
              if (icon != null) {
                selectedIcon = icon;
              }
            },
          ),
          ListTile(
            title: const Text('Pick Color'),
            trailing: CircleAvatar(
              backgroundColor: selectedColor,
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
                          selectedColor = color;
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
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle Cancel
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

            // You can now use these values to create a new category and add it to your provider or state management solution

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
