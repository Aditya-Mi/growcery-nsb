import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
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
    final isInternetAvailable = await ref.refresh(networkProvider.future);
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -639,
            left: -235,
            child: Container(
              width: 906,
              height: 906,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: homeScreenCircle,
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: addresses.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome',
                                style: CustomTextStyle.boldTextStyleBlack(
                                    fontSize: 26),
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
                                icon: SvgPicture.asset(
                                  'assets/icons/pin.svg',
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const EditAddress(),
                                    ),
                                  );
                                },
                                label: Text(
                                  'Add address',
                                  style: CustomTextStyle.mediumTextStyleDark(
                                          fontSize: 12)
                                      .copyWith(inherit: true),
                                ),
                              ),
                            ],
                          );
                        } else {
                          Address address = data[0];
                          final finalAddress =
                              "${address.locality}, ${address.landmark}, ${address.city}, ${address.state}";
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.fullName,
                                      style: CustomTextStyle.boldTextStyleBlack(
                                          fontSize: 20),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      finalAddress,
                                      style: CustomTextStyle.mediumTextStyle(
                                          fontSize: 14, color: grey),
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
                                label: Text(
                                  'Add address',
                                  style: CustomTextStyle.mediumTextStyleDark(
                                          fontSize: 12)
                                      .copyWith(inherit: true),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.rectangular(
                                width: w * 0.5, height: 30),
                            const Spacer(),
                            ShimmerWidget.circular(
                              width: w * 0.3,
                              height: 40,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SliverAppBar(
                  backgroundColor: homeScreenCircle,
                  scrolledUnderElevation: 0.0,
                  pinned: true,
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: SizedBox(),
                  ),
                  expandedHeight: 60,
                  title: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
            body: ListView(
              children: [
                const HomeHeading(
                  heading: 'Categories',
                ),
                categories.when(
                  data: (data) {
                    return SizedBox(
                      width: double.infinity,
                      height: h * 0.45,
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
                    debugPrint(stackTrace.toString());
                    return const Center(
                      child: Text(
                        'Something went wrong. Please try again later.',
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    width: double.infinity,
                    height: h * 0.45,
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
                  height: h * 0.3528,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: products.when(
                    data: (data) {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 20,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length <= 5 ? data.length : 5,
                        itemBuilder: (context, index) {
                          return GroceryItem(
                            product: data[index],
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      debugPrint(stackTrace.toString());
                      return const Center(
                        child: Text(
                          'Something went wrong. Please try again later.',
                        ),
                      );
                    },
                    loading: () {
                      return Container(
                        height: h * 0.2528,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
