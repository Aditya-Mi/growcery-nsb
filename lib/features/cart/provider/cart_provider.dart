import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/data/cart_item.dart';
import 'package:grocery_app/features/cart/repository/cart_repository.dart';

final cartItemsProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  () => CartNotifier(),
);

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  CartRepository get _cartRepository => ref.read(cartRepositoryProvider);

  @override
  Future<List<CartItem>> build() => getCartItems();

  Future<void> addItemToCart(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.addItemToCart(id);
    });
  }

  Future<void> deleteItemFromCart(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.deleteItemFromCart(id);
    });
  }

  Future<void> increaseQuantityItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.increaseQuantityItem(id);
    });
  }

  Future<void> decreaseQuantityItem(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.decreaseQuantityItem(id);
    });
  }

  bool isInCart(String id) {
    var contain = state.value?.where((element) => element.itemDetails.id == id);
    if (contain != null && contain.isEmpty) {
      return false;
    }
    return true;
  }

  bool isCartLoaded() {
    return state.asData != null;
  }

  int getQuantity(String id) {
    final cartItem =
        state.value!.firstWhere((element) => element.itemDetails.id == id);
    return cartItem.quantity;
  }

  Future<List<CartItem>> getCartItems() async {
    return await _cartRepository.getCartItems();
  }
}
