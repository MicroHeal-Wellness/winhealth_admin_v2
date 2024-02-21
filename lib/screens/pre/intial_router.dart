// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/auth/login_screen.dart';
import 'package:winhealth_admin_v2/screens/batch_slot_update.dart';
import 'package:winhealth_admin_v2/screens/foms_home.dart';
import 'package:winhealth_admin_v2/screens/landing_screen.dart';
import 'package:winhealth_admin_v2/services/auth_service.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class InitialRouter extends StatefulWidget {
  const InitialRouter({super.key});

  @override
  State<InitialRouter> createState() => _InitialRouterState();
}

class _InitialRouterState extends State<InitialRouter> {
  @override
  void initState() {
    super.initState();
    runInitFunc();
  }

  runInitFunc() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isLogin = prefs.getBool('isLogin');
      if (isLogin == null || isLogin == false) {
        print("isLogin $isLogin");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        UserModel? currentUser = await BaseService.getCurrentUser();
        if (currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LandingScreen(),
            ),
          );
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => BatchSlotUpdate(currentUser: currentUser),
          //   ),
          // );
        } else {
          Fluttertoast.showToast(msg: "Not a valid user type");
          await AuthService.logOut(context);
          // logout
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
