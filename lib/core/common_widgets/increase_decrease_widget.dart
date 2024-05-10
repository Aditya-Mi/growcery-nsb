import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final double size = isItemDetailScreen ? 36.00 : 20.00;
    final double fontSize = isItemDetailScreen ? 18 : 14;
    final double iconSize = isItemDetailScreen ? 16 : 14;
    final double gap = isItemDetailScreen ? 16 : 10;
    return Row(
      children: [
        GestureDetector(
          onTap: decreaseOnPressed,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "assets/icons/minus.svg",
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: gap),
        Text(
          '$quantity',
          style: CustomTextStyle.boldTextStyleDark(fontSize: fontSize),
        ),
        SizedBox(width: gap),
        GestureDetector(
          onTap: increaseOnPressed,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: Icon(
              Icons.add,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
