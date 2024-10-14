import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/products/data/product.dart';

final searchUserProvider = StateProvider<String>((ref) => '');

class SearchUserController extends StateNotifier<List<Product>> {
  SearchUserController() : super([]);
  void onSearchUser(String query, List<Product> data) {
    state = [];
    if (query.isNotEmpty) {
      final result = data
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()))
          .toList();
      state.addAll(result);
    }
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchUserController, List>((ref) {
  return SearchUserController();
});
