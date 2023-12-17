import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Ref ref;
  AuthRepository({
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

  Future<String> receiveOtp(String phoneNo) async {
    String url = 'https://growcery-x6sg.onrender.com/api/v1/auth/otp';
    String res = '';
    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'mobile': '91$phoneNo'}),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var res = result['otp'];
        return res;
      }
    } catch (e) {
      return res = e.toString();
    }
    return res;
  }

  bool verfiyOtp(String receivedOtp, String enteredOtp) {
    if (receivedOtp == enteredOtp) {
      return true;
    }
    return false;
  }

  Future<String> signInWithOtp(String phoneNo, String otp) async {
    String res = '';
    var url =
        Uri.parse('https://growcery-x6sg.onrender.com/api/v1/auth/signup');
    try {
      var response = await http.post(
        url,
        body: jsonEncode({'mobile': '91$phoneNo', 'otp': otp}),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String res = result['token'];
        return res;
      }
    } catch (e) {
      return res;
    }
    return res;
  }

  Future<bool> logout() async {
    var url =
        Uri.parse('https://growcery-x6sg.onrender.com/api/v1/auth/logout');
    try {
      var response = await http.post(
        url,
        headers: await _getHeader(),
      );
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

final authRepositoryProvider = Provider((ref) => AuthRepository(ref: ref));
