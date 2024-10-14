import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';

class CustomButton2 extends StatelessWidget {
  final Widget child;
  final void Function()? function;
  const CustomButton2({super.key, required this.child, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primaryColor,
        ),
        child: child,
      ),
    );
  }
}
