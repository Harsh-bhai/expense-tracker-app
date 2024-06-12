import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

class ListTileModel {
  final String? title;
  final String? subtitle;
  final Widget? page;
  final IconData? icon;
  final String? categoryName;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? iconColor;
  final BuildContext? context;
  const ListTileModel({this.title, this.subtitle, this.page, this.icon,this.categoryName,this.onTap,this.bgColor,this.iconColor,this.context});
}