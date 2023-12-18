import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/presentation/items_screen.dart';
import 'package:grocery_app/features/products/presentation/widgets/grocery_item.dart';
import 'package:grocery_app/features/products/presentation/widgets/home_category_list_item.dart';
import 'package:grocery_app/features/products/presentation/widgets/home_heading_item.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';
import 'package:grocery_app/features/products/provider/product_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

  Future<void> checkInternetConnection() async {
    final isInternetAvailable = await ref.read(networkProvider.future);
    if (!isInternetAvailable && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final categories = ref.watch(categoryProvider);
    final products = ref.watch(productProvider);
    final addresses = ref.watch(addressProvider);
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
                  child: addresses.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DMSans',
                                color: Colors.black,
                              ),
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
                        );
                      } else {
                        Address address = data[0];
                        final finalAddress =
                            "${address.locality}, ${address.landmark}, ${address.city}, ${address.state}";
                        return SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.fullName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      finalAddress,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'DMSans',
                                        color: grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
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
                        );
                      }
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
                    onChanged: (value) {},
                    onEditingComplete: () {},
                  ),
                ),
              )
            ];
          },
          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      color: dark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSans',
                    ),
                  ),
                ),
                categories.when(
                  data: (data) {
                    return Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 25,
                          childAspectRatio: 1,
                        ),
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
                        itemCount: data.length,
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 25,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return const HomeCategoryShimmerListItem();
                      },
                      itemCount: 12,
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
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return const GroceryShimmerListItem();
                        },
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
