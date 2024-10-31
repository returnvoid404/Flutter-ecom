import 'dart:async';

import 'package:ecom/controllers/user_data_controller.dart';
import 'package:ecom/screens/admin-panel/admin_home_screen.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggedin(context);
    });
  }

  Future<void> loggedin(BuildContext context) async {
    if (user != null) {
      final UserDataController userDataController =
          Get.put(UserDataController());
      var userdata = await userDataController.userdata(user!.uid);
      if (userdata[0]['isAdmin'] == true) {
        Get.offAll(() => const AdminHomeScreen());
      } else {
        Get.offAll(() => const Home());
      }
    } else {
      Get.offAll(() => const LogInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        alignment: Alignment.center,
        child: Lottie.asset('assets/images/splash.json'),
      ),
    );
  }
}
