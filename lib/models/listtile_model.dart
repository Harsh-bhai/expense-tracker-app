import 'package:flutter/material.dart';

class ListTileModel {
  String? title;
  String? subtitle;
  Widget? page;
  IconData? icon;
  String? categoryName;
  VoidCallback? onTap;
  Color? bgColor;
  Color? iconColor;
  BuildContext? context;
  ListTileModel({this.title, this.subtitle, this.page, this.icon,this.categoryName,this.onTap,this.bgColor,this.iconColor,this.context});
}