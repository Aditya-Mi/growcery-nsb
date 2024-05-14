import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/products/data/category.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/presentation/items_screen.dart';
import 'package:grocery_app/features/products/presentation/widgets/home_category_list_item.dart';
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
        title: const Text('Categories'),
      ),
      body: categories.when(
        data: (data) {
          Map<String, int> categoryLengths = {};
          for (var category in data) {
            categoryLengths[category.name] = category.name.length;
          }
          List<Category> sortedCategories = data.toList()
            ..sort((a, b) =>
                categoryLengths[b.name]!.compareTo(categoryLengths[a.name]!));
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              mainAxisExtent: 120,
            ),
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ref.read(filterProvider.notifier).update(
                        (state) => Filters(
                          category: sortedCategories[index].name,
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
                  category: sortedCategories[index],
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
