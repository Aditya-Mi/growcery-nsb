import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/cart/repository/cart_repository.dart';

final cartItemsProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  () => CartNotifier(),
);

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  CartRepository get _cartRepository => ref.read(cartRepositoryProvider);

  @override
  Future<List<CartItem>> build() => getCart();

  Future<void> addItemToCart(CartItem cartItem) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.addItemToCart(cartItem);
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
    var contain = state.value?.where((element) => element.id == id);
    if (contain != null && contain.isEmpty) {
      return false;
    }
    return true;
  }

  bool isCartLoaded() {
    return state.asData != null;
  }

  int getQuantity(String id) {
    final cartItem = state.value!.firstWhere((element) => element.id == id);
    return cartItem.quantity;
  }

  Future<List<CartItem>> getCart() async {
    return await _cartRepository.getCartItems();
  }

  // Future<bool> placeOrder(String addressId) async {
  //   final response = await _cartRepository.placeOrder(addressId);
  //   return response;
  // }
}
