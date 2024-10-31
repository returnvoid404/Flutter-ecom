import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> userdata(String uId) async {
    final QuerySnapshot userdata = await firebasefirestore
        .collection('users')
        .where('uId', isEqualTo: uId)
        .get();
    return userdata.docs;
  }
}
