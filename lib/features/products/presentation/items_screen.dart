import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/presentation/widgets/grocery_item.dart';
import 'package:grocery_app/features/products/provider/product_provider.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({
    super.key,
  });

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  void bottomSheet(BuildContext context) {
    List<String> options = [
      'Deafult',
      'Price low to high',
      'Price high to low',
    ];
    String currentOption = options[0];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          floatingActionButton: Container(
            transform: Matrix4.translationValues(0.0, -60.0, 0.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Sort by',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const Divider(),
              RadioListTile(
                title: Text(
                  options[0],
                ),
                value: options[0],
                groupValue: currentOption,
                onChanged: (value) {
                  ref.read(filterProvider.notifier).update(
                        (state) => Filters(
                          category: null,
                          priceSort: null,
                          ratingSort: null,
                          isVeg: null,
                        ),
                      );
                  setState(() {
                    currentOption = value.toString();
                    Navigator.of(context).pop();
                  });
                },
              ),
              RadioListTile(
                title: Text(
                  options[1],
                ),
                value: options[1],
                groupValue: currentOption,
                onChanged: (value) {
                  ref.read(filterProvider.notifier).update(
                        (state) => Filters(
                          category: state.category,
                          priceSort: SortState.asc,
                          ratingSort: state.ratingSort,
                          isVeg: state.isVeg,
                        ),
                      );
                  setState(() {
                    currentOption = value.toString();
                    Navigator.of(context).pop();
                  });
                },
              ),
              RadioListTile(
                title: Text(
                  options[2],
                ),
                value: options[2],
                groupValue: currentOption,
                onChanged: (value) {
                  ref.read(filterProvider.notifier).update(
                        (state) => Filters(
                          category: state.category,
                          priceSort: SortState.desc,
                          ratingSort: state.ratingSort,
                          isVeg: state.isVeg,
                        ),
                      );
                  setState(() {
                    currentOption = value.toString();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    final filters = ref.watch(filterProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(filterProvider.notifier).update(
              (state) => Filters(
                category: null,
                priceSort: null,
                ratingSort: null,
                isVeg: null,
              ),
            );
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Items',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: products.when(
          data: (data) {
            List<Product> filteredList = data;
            if (filters.category != null) {
              filteredList = filteredList
                  .where((product) =>
                      product.category.name == filters.category!.name)
                  .toList();
            }
            if (filters.isVeg != null) {
              if (filters.isVeg == true) {
                filteredList =
                    filteredList.where((product) => product.isVeg).toList();
              }
            }
            if (filters.priceSort != null) {
              if (filters.priceSort == SortState.asc) {
                filteredList.sort((a, b) => a.price.compareTo(b.price));
              } else {
                filteredList.sort((a, b) => b.price.compareTo(a.price));
              }
            }
            // if(filters.ratingSort != null){
            //    switch (filters.priceSort){
            //      case SortState.asc:
            //        filteredList.sort((a, b) => a.rating.compareTo(b.rating));
            //      case SortState.desc:
            //        filteredList.sort((a, b) => b.rating.compareTo(a.rating));
            //      default:
            //    }
            // }
            return filteredList.isEmpty
                ? const Center(
                    child: Text('No items found'),
                  )
                : Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                bottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: lightPrimary),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/sort.svg'),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'Sort',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: lightPrimary),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Type',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (filters.isVeg == null ||
                                    filters.isVeg == false) {
                                  ref.read(filterProvider.notifier).update(
                                        (state) => Filters(
                                          category: state.category,
                                          priceSort: state.priceSort,
                                          ratingSort: state.ratingSort,
                                          isVeg: true,
                                        ),
                                      );
                                } else {
                                  ref.read(filterProvider.notifier).update(
                                        (state) => Filters(
                                          category: state.category,
                                          priceSort: state.priceSort,
                                          ratingSort: state.ratingSort,
                                          isVeg: null,
                                        ),
                                      );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: lightPrimary),
                                    color: filters.isVeg == true
                                        ? lightPrimary
                                        : Colors.white),
                                child: Row(
                                  children: [
                                    Text(
                                      'Veg',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: filters.isVeg != null &&
                                                filters.isVeg == true
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.76168224299,
                          ),
                          itemBuilder: (context, index) {
                            return GroceryItem(
                              product: filteredList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}