import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

class ListTileModel {
  final String? title;
  final String? subtitle;
  final Widget? page;
  final IconData? icon;
  final Expense? expenseEnum;
  const ListTileModel({this.title, this.subtitle, this.page, this.icon, this.expenseEnum});
}