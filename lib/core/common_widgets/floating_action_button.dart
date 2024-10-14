import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -60.0, 0.0),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
