import 'package:flutter/material.dart';
class BankModel {
  String bankName;
  RegExp creditRegex;
  RegExp debitRegex;
  RegExp moneyRegex;
  Image image;
  List<String> debitSenders;
  List<String> creditSenders;
  BankModel(
      {required this.bankName,
      required this.image,
      required this.debitRegex,
      required this.creditRegex,
      required this.moneyRegex,
      required this.debitSenders,
      required this.creditSenders
      });
}