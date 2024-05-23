import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/images.dart';

class HomeDeliverCard extends StatelessWidget {
  const HomeDeliverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage(Images.homeDeliver),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
