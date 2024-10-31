import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceTokenController extends GetxController {
  String? devicetoken;

  @override
  void onInit() {
    super.onInit();
    devicetokenmethod();
  }

  Future<void> devicetokenmethod() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        devicetoken = token;
        update();
      }
    } catch (e) {
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
