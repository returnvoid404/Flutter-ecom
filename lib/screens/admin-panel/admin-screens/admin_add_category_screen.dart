// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/screens/admin-panel/admin-screens/admin_all_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../../../services/generate_random_id_service.dart';
import '../admin-controllers/admin_category_images_controller.dart';

class AdminAddCategoriesScreen extends StatefulWidget {
  const AdminAddCategoriesScreen({super.key});

  @override
  State<AdminAddCategoriesScreen> createState() =>
      _AdminAddCategoriesScreenState();
}

class _AdminAddCategoriesScreenState extends State<AdminAddCategoriesScreen> {
  TextEditingController categoryNameController = TextEditingController();
  AddCategoryImagesController addCategoryImagesController =
      Get.put(AddCategoryImagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Categories"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Images"),
                    ElevatedButton(
                      onPressed: () {
                        addCategoryImagesController.ShowImagesPickerDialog();
                      },
                      child: const Text("Select Images"),
                    )
                  ],
                ),
              ),

              //show Images
              GetBuilder<AddCategoryImagesController>(
                init: AddCategoryImagesController(),
                builder: (imageController) {
                  return imageController.selectedImages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedImages.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addCategoryImagesController
                                        .selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImages(index);
                                        print(imageController
                                            .selectedImages.length);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.amber,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 40.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: Colors.amber,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  await addCategoryImagesController.uploadFunction(
                      addCategoryImagesController.selectedImages);
                  String categoryId =
                      await GenerateProductIds().generateProductId();
                  String cateImg = addCategoryImagesController.arrImagesUrl[0]
                      .toString() as String;

                  print(cateImg);

                  CategoryModel categoriesModel = CategoryModel(
                    categoryId: categoryId,
                    categoryName: categoryNameController.text.trim(),
                    categoryImg: cateImg,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  print(categoryId);

                  // //
                  FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryId)
                      .set(categoriesModel.toMap());

                  EasyLoading.dismiss();
                  Get.snackbar(
                    "Success",
                    "Successfully added the product.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.amber,
                    colorText: Colors.black,
                  );
                  Get.offAll(() => AdminAllCategoriesScreen());
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
