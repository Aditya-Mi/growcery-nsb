import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'ADD',
          style: CustomTextStyle.boldTextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
