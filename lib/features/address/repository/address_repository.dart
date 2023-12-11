import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:http/http.dart' as http;

final addressRepositoryProvider =
    Provider((ref) => AddressRepository(ref: ref));

class AddressRepository {
  String url = 'https://growcery-x6sg.onrender.com/api/v1/address';
  Ref ref;
  AddressRepository({
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

  Future<List<Address>> getAddresses() async {
    try {
      var u = Uri.parse('$url/getaddress');
      var response = await http.get(u, headers: await _getHeader());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body)['addresses'];
        List<Address> addresses = result
            .map<Address>((address) => Address.fromJson(address))
            .toList();
        return addresses;
      }
      throw Exception(response.reasonPhrase);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw e.toString();
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      var u = Uri.parse('$url/deleteaddress/$id');
      var response = await http.delete(u, headers: await _getHeader());
      if (response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return false;
  }

  Future<bool> addAddress(Address address) async {
    try {
      var u = Uri.parse('$url/addaddress');
      final address1 = jsonEncode(address.toJson());
      var response =
          await http.post(u, headers: await _getHeader(), body: address1);
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return false;
  }
}
