import 'package:flutter/material.dart';

class Helper {
  static void showSnackbar(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data),
      ),
    );
  }
}
