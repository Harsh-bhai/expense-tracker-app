import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_listtile_model.g.dart';

@HiveType(typeId: 0)
class HiveListTileModel extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? subtitle;

  @HiveField(2)
  String? page;

  @HiveField(3)
  int? iconCodePoint;

  @HiveField(4)
  String? iconFontFamily;

  @HiveField(5)
  String? iconFontPackage;

  @HiveField(6)
  int? bgColorValue;


  HiveListTileModel({
    this.title,
    this.subtitle,
    this.page,
    IconData? icon,
    this.iconFontFamily,
    this.iconFontPackage,
    Color? bgColor,
  }) {
    // Initialize icon fields
    if (icon != null) {
      iconCodePoint = icon.codePoint;
      iconFontFamily = icon.fontFamily;
      iconFontPackage = icon.fontPackage;
    }
    bgColorValue = bgColor?.value;
  }

  IconData? get iconData {
    if (iconCodePoint == null) return null;
    return IconData(
      iconCodePoint!,
      fontFamily: iconFontFamily,
      fontPackage: iconFontPackage,
    );
  }

  Color? get bgColor => bgColorValue == null ? null : Color(bgColorValue!);
}
