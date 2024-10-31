import 'dart:math';

import 'package:uuid/uuid.dart';

String generateOrderId() {
  DateTime now = DateTime.now();

  int randomnumbers = Random().nextInt(99999);
  String id = '${now.microsecondsSinceEpoch}_$randomnumbers';
  return id;
}

class GenerateProductIds {
  String generateProductId() {
    String formattedProductId;
    String uuid = const Uuid().v4();

    formattedProductId = "Beez-Bag-${uuid.substring(0, 6)}";
    return formattedProductId;
  }
}

String generateProductId() {
  String formattedcategoryId;
  String uuid = const Uuid().v4();

  formattedcategoryId = "Beez-Bag-${uuid.substring(0, 6)}";
  return formattedcategoryId;
}
