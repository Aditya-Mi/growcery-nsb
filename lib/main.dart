// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/authentication/presentation/login_screen.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/main_screen.dart';
import 'package:grocery_app/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? onBoarding;
String? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onBoarding = await prefs.getBool('onBoarding');
  token = await prefs.getString(authenticationToken);
  token ??= '';
  onBoarding ??= true;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'DMSans',
        useMaterial3: true,
      ),
      home: onBoarding! == true
          ? const OnBoardingScreen()
          : token != ''
              ? const OnBoardingScreen()
              : const OnBoardingScreen(),
    );
  }
}
