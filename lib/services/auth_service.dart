// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/auth/login_screen.dart';
import 'package:winhealth_admin_v2/screens/auth/otp_verify_screen.dart';
import 'package:winhealth_admin_v2/screens/landing_screen.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // sign in with phone number
  static Future signInWithPhone(context, phoneNumber, isLogin) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    TextEditingController pinController = TextEditingController(text: "");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91$phoneNumber",
          verificationCompleted: (PhoneAuthCredential credential) async {
            // await FirebaseAuth.instance.signInWithCredential(credential);
            if (kDebugMode) {
              print("verification completed");
            }
            // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
          timeout: const Duration(seconds: 00),
          verificationFailed: (e) {
            if (kDebugMode) {
              print("verification failed, ${e.toString()}");
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error occurred while accessing credentials. $e.',
                ),
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                  pinController: pinController,
                  phoneNumber: phoneNumber,
                  onCompleted: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    if (kDebugMode) {
                      print("pressed + ${pinController.text.trim()}");
                    }
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: pinController.text.trim(),
                    );
                    try {
                      UserCredential result = await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      bool exhists =
                          await checkUserExists('$phoneNumber@winhealth.com');
                      if (kDebugMode) {
                        print("result: ${result.user!.uid}, exhists: $exhists");
                      }
                      if (!isLogin && exhists) {
                        Fluttertoast.showToast(
                            msg:
                                "User already exists!, Signing in automatically");
                        await serverSignIn(
                          '$phoneNumber@winhealth.com',
                          result.user!.uid,
                          context,
                        );
                      } else if (isLogin) {
                        await serverSignIn(
                          '$phoneNumber@winhealth.com',
                          result.user!.uid,
                          context,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "User not found!, please try again");
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => SignUpScreen(
                        //       email: '$phoneNumber@winhealth.com',
                        //       password: result.user!.uid,
                        //       phone: phoneNumber,
                        //     ),
                        //   ),
                        // );
                      }
                    } catch (e) {
                      if (e.toString().contains(
                          "The verification code from SMS/TOTP is invalid.")) {
                        Fluttertoast.showToast(
                            msg: "Wrong verification code from SMS/TOTP");
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'Error occurred while accessing credentials. Try again.');
                      }
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            // Fluttertoast.showToast(msg: "OTP Timed Out");
          });
    }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'invalid-verification-code') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'The account already exists with a different credential',
    //         ),
    //       ),
    //     );
    //   } else if (e.code == 'invalid-credential') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Error occurred while accessing credentials. Try again.',
    //         ),
    //       ),
    //     );
    //   } else {
    //     print("------------------------------- ${e.code}");
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Error occurred while accessing credentials. Try again.',
    //         ),
    //       ),
    //     );
    //   }
    // }
    catch (e) {
      print("------------------------------- ${e}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error occurred while accessing credentials. Try again.',
          ),
        ),
      );
    }
  }

  static Future<bool> checkUserExists(String email) async {
    var resp = await BaseService.makeUnauthenticatedRequest(
        "${BaseService.BASE_URL}/users/chkuser",
        method: 'PSOT',
        body: jsonEncode({"email": email}));
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    var resp = await BaseService.makeUnauthenticatedRequest(
      "${BaseService.BASE_URL}/users?filter[email][_eq]=$email&fields=*,access.*",
      method: 'GET',
    );
    if (resp.statusCode == 200) {
      var respMap = jsonDecode(resp.body);
      if (respMap['data'].length > 0) {
        return UserModel.fromJson(respMap['data'][0]);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future signInWithGoogle(context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      // UserCredential result =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      UserCredential result =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      print(result.user!.email);
      if (result.user != null) {
        await serverSignIn(result.user!.email, result.user!.uid, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error occurred while accessing server credentials. Try again.',
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error occurred while accessing credentials. Try again.',
          ),
        ),
      );
    }
  }

  static Future<void> serverSignIn(email, password, context) async {
    try {
      var resp = await BaseService.makeUnauthenticatedRequest(
        "${BaseService.BASE_URL}/auth/login",
        method: 'POST',
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        if (kDebugMode) {
          print("data: $data");
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel? user = await getUserByEmail(email);
        if (user != null) {
          BaseService.saveToken(
            data['data']['access_token'],
            data['data']['refresh_token'],
            user.toJson(),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LandingScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Sign In Failed, Please Try again!");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Sign In Failed, User Doesn't Exists, Please Try again!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return;
    }
  }

  static Future<void> serverSignUp(payload, context) async {
    try {
      var resp = await BaseService.makeUnauthenticatedRequest(
        "${BaseService.BASE_URL}/signup",
        method: 'POST',
        body: jsonEncode(payload),
      );
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        if (kDebugMode) {
          print("data: $data");
        }
        BaseService.saveToken(
          data['token'],
          data['refresh_token'],
          data['user'],
        );
        // UserModel currentUser = UserModel.fromJson(data['user']);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => BasicBioScreen(
        //       meUser: currentUser,
        //     ),
        //   ),
        // );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        Fluttertoast.showToast(msg: "Sign Up Failed, Please Try Again!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return;
    }
  }

  static Future<void>? logOut(context) {
    SharedPreferences.getInstance().then((value) {
      value.setBool("isLogin", false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    return null;
  }
}
