import 'package:flutter/material.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/products/data/category.dart';

class HomeCategoryListItem extends StatelessWidget {
  final Category category;
  const HomeCategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://growcery-x6sg.onrender.com';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightBg,
            image: DecorationImage(
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                return;
              },
              image: NetworkImage('$baseUrl' '${category.image.substring(6)}'),
            ),
          ),
        ),
        const Spacer(),
        Text(
          category.name,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: dark,
          ),
        ),
      ],
    );
  }
}
