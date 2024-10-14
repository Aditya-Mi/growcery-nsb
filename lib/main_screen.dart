import 'package:flutter/material.dart';
import 'package:grocery_app/features/cart/presentation/cart_screen.dart';
import 'package:grocery_app/features/products/presentation/categories_screen.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/features/products/presentation/home_screen.dart';
import 'package:grocery_app/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          CategoriesScreen(),
          CartScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: _page == 0 ? Colors.black : lightGrey2,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset(
                'assets/icons/categories.svg',
                color: _page == 1 ? Colors.black : lightGrey2,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset(
                'assets/icons/bag.svg',
                color: _page == 2 ? Colors.black : lightGrey2,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: SvgPicture.asset(
                'assets/icons/profile.svg',
                color: _page == 3 ? Colors.black : lightGrey2,
              ),
            ),
          ],
          onTap: navigationTap,
        ),
      ),
    );
  }
}
