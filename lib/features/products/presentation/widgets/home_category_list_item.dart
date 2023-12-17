import 'package:flutter/material.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/products/data/category.dart';

class HomeCategoryListItem extends StatelessWidget {
  final Category category;
  const HomeCategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://growcery-x6sg.onrender.com';
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w * 0.2,
      height: h * 0.0918,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: h * 0.089,
            height: w * 0.194,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightBg,
              image: DecorationImage(
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  return;
                },
                image:
                    NetworkImage('$baseUrl' '${category.image.substring(6)}'),
              ),
            ),
          ),
          Text(
            category.name,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: h * 0.01658,
              fontWeight: FontWeight.w500,
              color: dark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
