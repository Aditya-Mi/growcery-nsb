import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/presentation/items_screen.dart';
import 'package:grocery_app/features/products/presentation/widgets/category_list_item.dart';
import 'package:grocery_app/features/products/provider/product_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Categories'),
      ),
      body: categories.when(
        data: (data) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              childAspectRatio: 0.95168224299,
            ),
            itemCount: data.length,
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
                child: CategoryScreenItem(
                  category: data[index],
                ),
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
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
