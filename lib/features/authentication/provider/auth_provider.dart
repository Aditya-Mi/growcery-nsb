import 'package:grocery_app/features/authentication/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String authenticationToken = 'AUTHENTICATION_TOKEN';

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
    prefs.setString(authenticationToken, response);
    return true;
  }
}

final authTokenProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.watch(sharedPreferenceProvider);
  return prefs.getString(authenticationToken)!;
});
