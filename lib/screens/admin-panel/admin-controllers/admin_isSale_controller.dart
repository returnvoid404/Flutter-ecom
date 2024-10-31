import 'package:get/get.dart';

class IsSaleController extends GetxController {
  RxBool isSale = false.obs;

  void toggleisSale(bool value) {
    isSale.value = value;
    update();
  }
}
