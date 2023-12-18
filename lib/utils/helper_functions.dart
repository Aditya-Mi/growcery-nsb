// ignore_for_file: public_member_api_docs, sort_constructors_first
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