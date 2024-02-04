import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/authentication/presentation/otp_verification_screen.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';
import 'package:grocery_app/utils/helper_functions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneNoController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'We will send you a verification code',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: grey,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            IntrinsicWidth(
              child: TextField(
                controller: phoneNoController,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counter: Container(),
                  border: InputBorder.none,
                  hintText: '0000000000',
                  hintStyle: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '+91 |',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        if (phoneNoController.text.isEmpty ||
                            phoneNoController.text.length < 10) {
                          Helper.showSnackbar(
                              context, 'Please enter a valid phone no.');
                          return;
                        }

                        final isInternetAvailable =
                            await ref.refresh(networkProvider.future);
                        if (!isInternetAvailable && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No internet connection.'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        var otp = await ref
                            .read(authProvider.notifier)
                            .getOtp(phoneNoController.text);
                        setState(() {
                          isLoading = false;
                        });
                        if (context.mounted && otp != 'failure') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OtpVerificationScreen(
                                phoneNo: phoneNoController.text,
                                otp: otp,
                              ),
                            ),
                          );
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                            inherit: true,
                            fontFamily: 'DMSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          'By clicking on “Continue” you are agreeing to our ',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: grey,
                      ),
                    ),
                    TextSpan(
                      text: 'terms of use',
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: iris,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
