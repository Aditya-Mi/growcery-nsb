import 'package:flutter/material.dart';

class CustomButtonText extends StatelessWidget {
  final String title;
  const CustomButtonText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        inherit: true,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
