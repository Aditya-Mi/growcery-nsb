import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/images.dart';

class HomeDeliverCard extends StatelessWidget {
  const HomeDeliverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage(Images.homeDeliver),
        ),
      ),
    );
  }
}
