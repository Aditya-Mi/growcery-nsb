import 'package:flutter/material.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/products/data/category.dart';

class HomeCategoryListItem extends StatelessWidget {
  final Category category;
  const HomeCategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://growcery-x6sg.onrender.com';
    return SizedBox(
      width: 80,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: lightBg,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image:
                    NetworkImage('$baseUrl' '${category.image.substring(6)}'),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            category.name,
            style: CustomTextStyle.mediumTextStyleDark(
              fontSize: 11,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class HomeCategoryShimmerListItem extends StatelessWidget {
  const HomeCategoryShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w * 0.2,
      height: h * 0.0918,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerWidget.circular(
            width: h * 0.089,
            height: w * 0.194,
          ),
        ],
      ),
    );
  }
}
