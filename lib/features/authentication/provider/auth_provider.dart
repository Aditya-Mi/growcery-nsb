import 'package:grocery_app/features/authentication/repository/auth_repository.dart';
import 'package:grocery_app/main.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String authenticationToken = 'AUTHENTICATION_TOKEN';
const String mobileNo = 'PHONE_NUMBER';

final sharedPreferenceProvider = Provider((ref) async {
  return await SharedPreferences.getInstance();
});

final authProvider =
    StateNotifierProvider<AuthController, AsyncValue<dynamic>>((ref) {
  return AuthController(ref: ref);
});

class AuthController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;
  AuthController({
    required this.ref,
  }) : super(const AsyncData(null));

  Future<String> getOtp(String phoneNo) async {
    final response = await ref.read(authRepositoryProvider).receiveOtp(phoneNo);
    return response;
  }

  bool verify(String receivedOtp, String enteredOtp) {
    return ref.read(authRepositoryProvider).verfiyOtp(receivedOtp, enteredOtp);
  }

  Future<bool> login(String phoneNo, String otp) async {
    final response =
        await ref.read(authRepositoryProvider).signInWithOtp(phoneNo, otp);
    if (response == '') {
      return false;
    }
    final prefs = await ref.watch(sharedPreferenceProvider);
    await prefs.setString(authenticationToken, response);
    await prefs.setString(mobileNo, phoneNo);
    return true;
  }

  Future<bool> logout() async {
    final response = await ref.read(authRepositoryProvider).logout();
    if (!response) {
      return false;
    }
    final prefs = await ref.watch(sharedPreferenceProvider);
    // await prefs.setString(authenticationToken, '');
    // await prefs.setString(mobileNo, '');
    await prefs.clear();
    await prefs.setBool('onBoarding', false);
    return true;
  }
}

final authTokenProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.watch(sharedPreferenceProvider);
  return prefs.getString(authenticationToken)!;
});

final mobileNoProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.watch(sharedPreferenceProvider);
  return prefs.getString(mobileNo)!;
});
