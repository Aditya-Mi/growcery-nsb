import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/main_screen.dart';
import 'package:grocery_app/utils/snackbar.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNo;
  final String otp;
  const OtpVerificationScreen({
    super.key,
    required this.phoneNo,
    required this.otp,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  late String enteredOtp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          const Text(
            'Enter OTP',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Verification code sent to your mobile number',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: grey,
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 10,
            direction: Axis.horizontal,
            children: [
              _otpTextField(true, false, controller1),
              _otpTextField(false, false, controller2),
              _otpTextField(false, false, controller3),
              _otpTextField(false, false, controller4),
              _otpTextField(false, false, controller5),
              _otpTextField(false, true, controller6),
            ],
          ),
          const SizedBox(
            height: 52,
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
              onPressed: () async {
                if (controller1.text.isNotEmpty &&
                    controller2.text.isNotEmpty &&
                    controller3.text.isNotEmpty &&
                    controller4.text.isNotEmpty &&
                    controller4.text.isNotEmpty &&
                    controller5.text.isNotEmpty) {
                  enteredOtp = controller1.text +
                      controller2.text +
                      controller3.text +
                      controller4.text +
                      controller5.text +
                      controller6.text;
                  bool verfiy = ref
                      .read(authProvider.notifier)
                      .verify(widget.otp, enteredOtp);
                  if (verfiy) {
                    bool success = await ref
                        .read(authProvider.notifier)
                        .login(widget.phoneNo, enteredOtp);
                    if (success && context.mounted) {
                      Helper.showSnackbar(context, 'Logged in successfully');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    } else {
                      if (context.mounted) {
                        Helper.showSnackbar(context,
                            'There was an error logging in. Please try again later.');
                      }
                    }
                  } else {
                    Helper.showSnackbar(context, 'Otp didn\'t match');
                  }
                } else {
                  Helper.showSnackbar(context, 'Please fill all fields');
                }
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  inherit: true,
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Haven\'t recieved an OTP?',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: grey,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      inherit: true,
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: iris,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _otpTextField(bool first, last, TextEditingController controller) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        showCursor: true,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
