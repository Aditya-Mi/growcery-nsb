import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/custom_button.dart';
import 'package:grocery_app/common_widgets/custom_button_text.dart';
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
              children: [
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(
                  height: 32,
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 40),
                  child: CustomButton(
                    child: const CustomButtonText(title: 'Shop now'),
                    function: () async {
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
                  ),
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
