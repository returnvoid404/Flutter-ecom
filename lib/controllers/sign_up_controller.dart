// ignore_for_file: unused_field, body_might_complete_normally_nullable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/controllers/device_token_controller.dart';
import 'package:ecom/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final DeviceTokenController deviceTokenController =
      Get.put(DeviceTokenController());
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //for password visiblity
  var ispasswordvisible = true.obs;

  Future<UserCredential?> SignUpMethod(
    String username,
    String useremail,
    String userphone,
    String userpassword,
    String userdevicetoken,
  ) async {
    try {
      EasyLoading.show(status: "Please wait..");
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: useremail,
        password: userpassword,
      );

      //send verification email
      await userCredential.user!.sendEmailVerification();

      //storing data in model temporarily
      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: username,
        email: useremail,
        phone: userphone,
        userImg: '',
        userDeviceToken: deviceTokenController.devicetoken.toString(),
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: '',
      );

      //sending data to firebase
      _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
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
