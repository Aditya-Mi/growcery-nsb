import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/presentation/categories_screen.dart';
import 'package:grocery_app/features/products/presentation/items_screen.dart';
import 'package:grocery_app/features/products/presentation/widgets/grocery_item.dart';
import 'package:grocery_app/features/products/presentation/widgets/home_category_list_item.dart';
import 'package:grocery_app/features/products/presentation/widgets/home_heading_item.dart';
import 'package:grocery_app/features/products/provider/product_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final categories = ref.watch(categoryProvider);
    final products = ref.watch(productProvider);
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: lightBg,
                elevation: 0.0,
                floating: false,
                expandedHeight: 80,
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1682687220945-922198770e60?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'DMSans',
                              color: grey,
                            ),
                          ),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans',
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        icon: SvgPicture.asset('assets/icons/pin.svg'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EditAddress(),
                            ),
                          );
                        },
                        label: const Text(
                          'Add address',
                          style: TextStyle(
                            inherit: true,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                scrolledUnderElevation: 0.0,
                pinned: true,
                backgroundColor: lightBg,
                elevation: 0.0,
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(10),
                  child: SizedBox(),
                ),
                title: Container(
                  height: 60,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) {},
                    onEditingComplete: () {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/search.svg',
                        height: 24,
                        width: 24,
                        fit: BoxFit.scaleDown,
                      ),
                      hintText: 'Search',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                HomeHeading(
                  heading: 'Categories',
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoriesScreen(),
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 100,
                  child: categories.when(
                    data: (data) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length <= 5 ? data.length : 5,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ref.read(filterProvider.notifier).update(
                                    (state) => Filters(
                                      category: data[index].name,
                                      priceSort: state.priceSort,
                                      ratingSort: state.ratingSort,
                                      isVeg: state.isVeg,
                                    ),
                                  );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ItemsScreen(),
                                ),
                              );
                            },
                            child: HomeCategoryListItem(
                              category: data[index],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 20,
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(
                          error.toString(),
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                HomeHeading(
                  heading: 'Best selling',
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ItemsScreen(),
                      ),
                    );
                  },
                ),
                Container(
                  height: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: products.when(
                    data: (data) {
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: data.length <= 5 ? data.length : 5,
                        itemBuilder: (context, index) {
                          return GroceryItem(
                            product: data[index],
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(error.toString()),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
