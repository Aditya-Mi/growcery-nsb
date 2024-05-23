import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/core/common_widgets/floating_action_button.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/presentation/widgets/item_screen_item.dart';
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
          floatingActionButton: const CustomFloatingActionButton(),
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
    final categories = ref.read(categoryProvider).value;

    return WillPopScope(
      onWillPop: () async {
        ref.read(filterProvider.notifier).update(
              (state) => Filters(
                category: null,
                priceSort: null,
                ratingSort: null,
              ),
            );
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        backgroundColor: stroke,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
            ),
          ),
          title: const Text(
            'Items',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              icon: const Icon(
                Icons.search,
              ),
            )
          ],
          backgroundColor: stroke,
        ),
        body: products.when(
          data: (data) {
            final categoryList =
                categories!.map((category) => category.name).toList();
            List<Product> filteredList = data;
            if (filters.category != null) {
              filteredList = filteredList
                  .where((product) => product.category.name == filters.category)
                  .toList();
            }

            if (filters.priceSort != null) {
              if (filters.priceSort == SortState.asc) {
                filteredList.sort((a, b) => a.price.compareTo(b.price));
              } else {
                filteredList.sort((a, b) => b.price.compareTo(a.price));
              }
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          bottomSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor),
                            color: Colors.white,
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
                                  fontSize: 14,
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
                        width: 15,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 36,
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryColor),
                              color: Colors.white),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Type',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            underline: const SizedBox(),
                            items: categoryList.map(buildMenuItem).toList(),
                            value: filters.category,
                            onChanged: (value) => setState(
                              () {
                                ref.read(filterProvider.notifier).update(
                                      (state) => Filters(
                                        category: value,
                                        priceSort: state.priceSort,
                                        ratingSort: state.ratingSort,
                                      ),
                                    );
                              },
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
                filteredList.isEmpty
                    ? const Expanded(
                        child: Center(
                          child:
                              Text('No items found for the selected category.'),
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 20,
                            bottom: 20,
                          ),
                          itemCount: filteredList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.60,
                          ),
                          itemBuilder: (context, index) {
                            return ItemScreenItem(
                              product: filteredList[index],
                            );
                          },
                        ),
                      ),
              ],
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(),
        ),
      );
}
