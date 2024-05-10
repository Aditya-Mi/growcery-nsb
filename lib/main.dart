// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/authentication/presentation/login_screen.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/products/data/category.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/main_screen.dart';
import 'package:grocery_app/onboarding_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? onBoarding;
String? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<CartItem>('cart_box');
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
      title: 'Grocery App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: CustomTextStyle.appBarTextStyle(),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        fontFamily: 'DMSans',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: onBoarding! == true
          ? const OnBoardingScreen()
          : token != ''
              ? const MainScreen()
              : const LoginScreen(),
    );
  }
}
