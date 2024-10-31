import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCategoryImagesController extends GetxController {
  final ImagePicker picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> arrImagesUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> ShowImagesPickerDialog() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.mediaLibrary.request();
    }

    if (status == PermissionStatus.granted) {
      Get.defaultDialog(
          title: "Choose Image",
          middleText: "Pick the image from the camera or gallery?",
          actions: [
            ElevatedButton(
              onPressed: () {
                selectImages('Camera');
              },
              child: Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                selectImages('gallery');
              },
              child: Text('Gallery'),
            ),
          ]);
    }
    if (status == PermissionStatus.denied) {
      print("Error. Please allow permission to access this function");
      openAppSettings();
    }
    if (status == PermissionStatus.permanentlyDenied) {
      print("Error. Please allow permission to access this function");
      openAppSettings();
    }
  }

  Future<void> selectImages(String type) async {
    List<XFile> imgs = [];
    if (type == 'gallery') {
      try {
        imgs = await picker.pickMultiImage(imageQuality: 80);
        update();
      } catch (e) {
        print('Error: $e');
      }
    } else {
      final img =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (img != null) {
        imgs.add(img);
        update();
      }
    }
    if (imgs.isNotEmpty) {
      selectedImages.addAll(imgs);
      update();
    }
  }

  void removeImages(int index) {
    selectedImages.removeAt(index);
    update();
  }

  Future<void> uploadFunction(List<XFile> images) async {
    arrImagesUrl.clear();
    for (int i = 0; i < images.length; i++) {
      dynamic imageUrl = await uploadFile(images[i]);
      arrImagesUrl.add(imageUrl.toString());
    }
    update();
  }

  Future<String> uploadFile(XFile image) async {
    TaskSnapshot reference = await storageRef
        .ref()
        .child('category-images')
        .child(image.name + DateTime.now().toString())
        .putFile(File(image.path));

    return await reference.ref.getDownloadURL();
  }
}
