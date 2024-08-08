// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/auth/login_screen.dart';
import 'package:winhealth_admin_v2/screens/partner_module/partner_landing_screen.dart';
import 'package:winhealth_admin_v2/screens/patient_group_module/patient_group_landing_screen.dart';
import 'package:winhealth_admin_v2/screens/slot/batch_slot_update.dart';
import 'package:winhealth_admin_v2/screens/forms/foms_home.dart';
import 'package:winhealth_admin_v2/screens/pre/landing_screen.dart';
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
          if (currentUser.role == "881dbecd-f779-4c65-927d-b07d39b336cb") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PartnerLandingScreen(),
              ),
            );
          } else if (currentUser.role ==
              "1143c29d-1d63-439a-9cf6-8ed130d42af1") {
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
