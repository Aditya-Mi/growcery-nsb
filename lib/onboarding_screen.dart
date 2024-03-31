import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/authentication/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -80,
              left: -100,
              child: CustomPaint(
                foregroundPainter: CircleBlurPainter(
                  circleWidth: 276,
                ),
              ),
            ),
            Positioned(
              top: 95,
              left: 200,
              child: CustomPaint(
                foregroundPainter: CircleBlurPainter(
                  circleWidth: 276,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: Svg('assets/images/logo.svg'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 318,
                  child: Text(
                    'Get your makeup essentials delivered to your home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  width: 300,
                  child: Text(
                    'The best delivery app in town for delivering your cosmetics and more...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    fixedSize: const Size(190, 53),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onBoarding', false);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Shop now',
                    style: TextStyle(
                        inherit: true,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/images/onboarding.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({
    required this.circleWidth,
  });

  double circleWidth;
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = primaryColor.withOpacity(0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 176);
    Offset center = Offset(circleWidth / 2, circleWidth / 2);
    double radius = min(circleWidth / 2, circleWidth / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
