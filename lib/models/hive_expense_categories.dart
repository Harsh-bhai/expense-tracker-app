import 'package:expense_tracker/models/listtile_model.dart';
import 'package:hive/hive.dart';

part 'hive_expense_categories.g.dart';

@HiveType(typeId: 1)
class HiveExpenseCateogry extends HiveObject {
  HiveExpenseCateogry({required this.key, required this.categories});
  @override
  @HiveField(0)
  String key;

  @HiveField(1)
  List<ListTileModel> categories;

}
