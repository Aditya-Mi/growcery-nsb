import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/features/cart/data/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final cartRepositoryProvider = Provider((ref) => CartRepository(ref: ref));

class CartRepository {
  String url = 'https://growcery-x6sg.onrender.com/api/v1/items';
  Ref ref;
  CartRepository({
    required this.ref,
  });

  Future<Map<String, String>> _getHeader() async {
    String token = await ref.read(authTokenProvider.future);
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
  }

  Future<Cart> getCart() async {
    try {
      var u = Uri.parse('$url/getcartitems');
      var response = await http.get(u, headers: await _getHeader());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Cart.fromJson(result);
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Cart> addItemToCart(String id) async {
    try {
      var u = Uri.parse('$url/addtocart/$id');
      var response = await http.post(u, headers: await _getHeader());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Cart.fromJson(result);
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Cart> deleteItemFromCart(String id) async {
    print('delete function called in repo');
    try {
      var u = Uri.parse('$url/deleteitem/$id');
      var response = await http.delete(u, headers: await _getHeader());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        return Cart.fromJson(result);
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Cart> increaseQuantityItem(String id) async {
    try {
      var u = Uri.parse('$url/quantityincrease/$id');
      var response = await http.post(u, headers: await _getHeader());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Cart.fromJson(result);
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Cart> decreaseQuantityItem(String id) async {
    try {
      var u = Uri.parse('$url/quantitydecrease/$id');
      var response = await http.post(u, headers: await _getHeader());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Cart.fromJson(result);
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> placeOrder(String addressId) async {
    try {
      var u = Uri.parse('$url/order');
      var body = jsonEncode({"addressId": addressId});
      var response =
          await http.post(u, headers: await _getHeader(), body: body);
      var result = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
    return false;
  }
}
