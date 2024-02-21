import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:winhealth_admin_v2/services/auth_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String? phoneNumber;
  final TextEditingController? pinController;
  final VoidCallback onCompleted;
  const OtpVerifyScreen(
      {super.key,
      this.phoneNumber = '',
      this.pinController,
      required this.onCompleted});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
              color: Color(0xff1C1A33),
              borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 56,
              ),
              const Text(
                "Enter the OTP sent to you",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.phoneNumber!,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Pinput(
                length: 6,
                obscureText: false,
                controller: widget.pinController,
                defaultPinTheme: PinTheme(
                  width: 55,
                  height: 55,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                // ignore: avoid_print
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Resend?',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              MaterialButton(
                height: 65,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).canvasColor,
                onPressed: () => widget.onCompleted(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !loading
                        ? const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
