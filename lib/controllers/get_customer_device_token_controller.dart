import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> GetCustomerDeviceToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token;
    } else {
      throw Exception("Error");
    }
  } catch (e) {
    // Get.snackbar(
    //   //exception catching
    //   "Error: ",
    //   "$e",
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.amber,
    //   colorText: Colors.black,
    // );
    print("Error: $e");
    throw Exception("Error");
  }
}
