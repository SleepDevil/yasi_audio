import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(
  String text, {
  gravity = ToastGravity.CENTER,
  toastLength = Toast.LENGTH_SHORT,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey[600], // 灰色背景
    fontSize: 16.0,
  );
}
