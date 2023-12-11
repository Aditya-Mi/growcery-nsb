import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
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
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
