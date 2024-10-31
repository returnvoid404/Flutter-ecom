// ignore_for_file: unused_field, body_might_complete_normally_nullable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPassController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Forget Password Method
  Future<void> ForgetPassMethod(
    String useremail,
  ) async {
    try {
      EasyLoading.show(status: "Please wait..");
      await firebaseAuth.sendPasswordResetEmail(email: useremail);
      Get.snackbar(
        //exception catching
        "Request sent successfully",
        "Password reset link sent to $useremail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      Get.offAll(() => const LogInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        //exception catching
        "Error: ",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
    }
  }
}
