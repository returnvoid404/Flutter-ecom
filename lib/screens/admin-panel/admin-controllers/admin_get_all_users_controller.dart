import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetAllUsersController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      usercontrollersubscription;

  final Rx<int> usercollectionlength = Rx<int>(0);
  @override
  void onInit() {
    super.onInit();
    usercontrollersubscription = firebaseFirestore
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      usercollectionlength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    usercontrollersubscription.cancel();
    super.onClose();
  }
}
