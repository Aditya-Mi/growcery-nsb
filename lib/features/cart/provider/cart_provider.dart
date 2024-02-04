import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/cart/repository/cart_repository.dart';

final cartItemsProvider = AsyncNotifierProvider<CartNotifier, Cart>(
  () => CartNotifier(),
);

class CartNotifier extends AsyncNotifier<Cart> {
  CartRepository get _cartRepository => ref.read(cartRepositoryProvider);

  @override
  Future<Cart> build() => getCart();

  Future<void> addItemToCart(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _cartRepository.addItemToCart(id);
    });
  }

  Future<void> deleteItemFromCart(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      Cart cart = await _cartRepository.deleteItemFromCart(id);
      return cart;
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
    var contain =
        state.value?.cartItem.where((element) => element.itemDetails.id == id);
    if (contain != null && contain.isEmpty) {
      return false;
    }
    return true;
  }

  bool isCartLoaded() {
    return state.asData != null;
  }

  int getQuantity(String id) {
    final cartItem = state.value!.cartItem
        .firstWhere((element) => element.itemDetails.id == id);
    return cartItem.quantity;
  }

  Future<Cart> getCart() async {
    return await _cartRepository.getCart();
  }

  Future<bool> placeOrder(String addressId) async {
    final response = await _cartRepository.placeOrder(addressId);
    return response;
  }
}
