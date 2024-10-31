// ignore_for_file: unused_field, body_might_complete_normally_nullable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //for password visiblity
  var ispasswordvisible = true.obs;

  //Login Method
  Future<UserCredential?> LogInMethod(
    String useremail,
    String userpassword,
  ) async {
    try {
      //Making instance of signinwithemailandpassword
      EasyLoading.show(status: "Please wait..");
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: useremail,
        password: userpassword,
      );

      EasyLoading.dismiss();
      //returning credentials

      return userCredential;
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
