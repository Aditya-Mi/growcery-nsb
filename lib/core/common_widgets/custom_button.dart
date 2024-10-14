import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final void Function()? function;
  const CustomButton({super.key, required this.child, required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: child,
      ),
    );
  }
}
