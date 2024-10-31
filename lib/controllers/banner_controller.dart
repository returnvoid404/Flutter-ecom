import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchbannerUrls();
  }

  Future<void> fetchbannerUrls() async {
    try {
      QuerySnapshot bannerSnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      if (bannerSnapshot.docs.isNotEmpty) {
        bannerUrls.value = bannerSnapshot.docs
            .map((doc) => doc['imageURL'] as String)
            .toList();
      }
    } catch (e) {
      Text("$e");
    }
  }
}
