// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/auth/login_screen.dart';
import 'package:winhealth_admin_v2/screens/partner_module/partner_landing_screen.dart';
import 'package:winhealth_admin_v2/screens/patient_group_module/patient_group_landing_screen.dart';
import 'package:winhealth_admin_v2/screens/pre/landing_screen.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class AuthService {
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
      "${BaseService.BASE_URL}/users?filter[email][_eq]=$email&fields=*,access.*,patient_group.*,partner.*",
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
          if (user.role == "881dbecd-f779-4c65-927d-b07d39b336cb") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PartnerLandingScreen(),
              ),
            );
          } else if (user.role == "1143c29d-1d63-439a-9cf6-8ed130d42af1") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PatientGroupLandingScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LandingScreen(),
              ),
            );
          }
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
    return null;
  }
}
