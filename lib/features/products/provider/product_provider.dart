import 'package:grocery_app/features/products/data/category.dart';
import 'package:grocery_app/features/products/data/filters.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/repository/product_api_repository.dart';
import 'package:riverpod/riverpod.dart';

final productRepositoryProvider = Provider((ref) => ProductRepositoryApi());

final productProvider = FutureProvider<List<Product>>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return productRepository.getAllProducts();
});

final categoryProvider = FutureProvider<List<Category>>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return productRepository.getAllCategories();
});

final filterProvider = StateProvider<Filters>(
  (ref) => Filters(),
);
