import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:hive/hive.dart';

final cartRepositoryProvider = Provider((ref) => CartRepository());

class CartRepository {
  final _kCartBox = 'cart_box';
  late Box<CartItem> _cartBox;

  Future<List<CartItem>> getCartItems() async {
    try {
      _cartBox = Hive.box(_kCartBox);
      List<CartItem> cart = _cartBox.values.toList();
      return cart;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CartItem>> addItemToCart(CartItem cartItem) async {
    try {
      _cartBox.put(cartItem.id, cartItem);
      List<CartItem> cart = _cartBox.values.toList();
      return cart;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CartItem>> deleteItemFromCart(String id) async {
    try {
      _cartBox.delete(id);
      List<CartItem> cart = _cartBox.values.toList();
      return cart;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CartItem>> increaseQuantityItem(String id) async {
    try {
      final CartItem cartItem = _cartBox.get(id)!;
      cartItem.quantity += 1;
      _cartBox.put(cartItem.id, cartItem);
      List<CartItem> cart = _cartBox.values.toList();
      return cart;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CartItem>> decreaseQuantityItem(String id) async {
    try {
      final CartItem cartItem = _cartBox.get(id)!;
      cartItem.quantity -= 1;
      _cartBox.put(cartItem.id, cartItem);
      List<CartItem> cart = _cartBox.values.toList();
      return cart;
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<bool> placeOrder(String addressId) async {
  //   try {
  //     var u = Uri.parse('$url/order');
  //     var body = jsonEncode({"addressId": addressId});
  //     var response =
  //         await http.post(u, headers: await _getHeader(), body: body);
  //     if (response.statusCode == 200) {
  //       return true;
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     return false;
  //   }
  //   return false;
  // }
}
