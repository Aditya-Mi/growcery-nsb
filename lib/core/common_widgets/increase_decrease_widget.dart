import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';

class IncreaseDecreaseWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback increaseOnPressed;
  final VoidCallback decreaseOnPressed;
  final bool isItemDetailScreen;
  const IncreaseDecreaseWidget(
      {super.key,
      required this.quantity,
      required this.increaseOnPressed,
      required this.decreaseOnPressed,
      required this.isItemDetailScreen});

  @override
  Widget build(BuildContext context) {
    final double fontSize = isItemDetailScreen ? 16 : 14;
    final double iconSize = isItemDetailScreen ? 16 : 14;
    final double width = isItemDetailScreen ? 84 : 76;
    return Container(
      width: width,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: decreaseOnPressed,
            child: Icon(
              Icons.remove_rounded,
              size: iconSize,
              color: Colors.white,
            ),
          ),
          Text(
            '$quantity',
            style: CustomTextStyle.boldTextStyle(
                fontSize: fontSize, color: Colors.white),
          ),
          GestureDetector(
            onTap: increaseOnPressed,
            child: Icon(
              Icons.add,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
