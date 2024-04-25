import 'package:flutter/material.dart';

void snackBar(
  BuildContext context,
  String msg,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 1),
    content: Text(msg),
    backgroundColor: Colors.red,
  ));
}
