import 'package:flutter/material.dart';
import 'package:grocery_app/constants/colors.dart';

class HomeHeading extends StatelessWidget {
  final String heading;
  final VoidCallback function;
  const HomeHeading({super.key, required this.heading, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 18,
              color: dark,
              fontWeight: FontWeight.bold,
              fontFamily: 'DMSans',
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: function,
            child: const Text(
              'See all',
              style: TextStyle(
                inherit: true,
                fontFamily: 'DMSans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
