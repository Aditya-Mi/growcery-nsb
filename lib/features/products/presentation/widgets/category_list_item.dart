import 'package:flutter/material.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/products/data/category.dart';

class CategoryScreenItem extends StatelessWidget {
  final Category category;
  const CategoryScreenItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    String baseUrl = 'https://growcery-x6sg.onrender.com';
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: w * 0.4179,
          height: h * 0.1931,
          decoration: BoxDecoration(
            color: lightBg,
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                return;
              },
              image: NetworkImage(
                '$baseUrl' '${category.image.substring(6)}',
                scale: 0.5,
              ),
            ),
          ),
        ),
        Text(
          category.name,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        )
      ],
    );
  }
}
