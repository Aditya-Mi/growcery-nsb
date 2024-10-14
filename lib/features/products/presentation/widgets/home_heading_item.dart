import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';

class HomeHeading extends StatelessWidget {
  final String heading;
  final VoidCallback? function;
  const HomeHeading({super.key, required this.heading, this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading,
            style: CustomTextStyle.boldTextStyleDark(fontSize: 18),
          ),
          const Spacer(),
          function != null
              ? TextButton(
                  onPressed: function,
                  child: Text(
                    'See all',
                    style: CustomTextStyle.mediumTextStylePrimaryColor(
                            fontSize: 18)
                        .copyWith(inherit: true),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
