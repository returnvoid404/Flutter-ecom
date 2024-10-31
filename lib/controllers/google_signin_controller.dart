// ignore_for_file: unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/controllers/device_token_controller.dart';
import 'package:ecom/models/user_model.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignmeth = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signinwithgoogle() async {
    final DeviceTokenController deviceTokenController =
        Get.put(DeviceTokenController());
    try {
      final GoogleSignInAccount? googleaccount = await googleSignmeth.signIn();

      if (googleaccount != null) {
        EasyLoading.show(status: "Please wait..");
        final GoogleSignInAuthentication googleacountauth =
            await googleaccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleacountauth.accessToken,
          idToken: googleacountauth.idToken,
        );

        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        final User? user = userCredential.user;
        if (user != null) {
          UserModel usermodel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: deviceTokenController.devicetoken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
              city: '');

          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(usermodel.toMap());
          EasyLoading.dismiss();
          Get.offAll(() => const Home());
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error: ",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
    }
  }
}
