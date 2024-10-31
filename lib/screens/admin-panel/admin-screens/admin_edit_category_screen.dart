// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../admin-controllers/admin_edit_category_controller.dart';

class AdminEditCategoryScreen extends StatefulWidget {
  CategoryModel categoriesModel;
  AdminEditCategoryScreen({super.key, required this.categoriesModel});

  @override
  State<AdminEditCategoryScreen> createState() =>
      _AdminEditCategoryScreenState();
}

class _AdminEditCategoryScreenState extends State<AdminEditCategoryScreen> {
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryNameController.text = widget.categoriesModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.categoriesModel.categoryName),
      ),
      body: Container(
        child: Column(
          children: [
            GetBuilder(
              init: EditCategoryController(
                  categoriesModel: widget.categoriesModel),
              builder: (editCategory) {
                return editCategory.categoryImg.value != ''
                    ? Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: editCategory.categoryImg.value.toString(),
                            fit: BoxFit.contain,
                            height: Get.height / 5.5,
                            width: Get.width / 2,
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            child: InkWell(
                              onTap: () async {
                                EasyLoading.show();
                                await editCategory.deleteImagesFromStorage(
                                    editCategory.categoryImg.value.toString());
                                await editCategory.deleteImageFromFireStore(
                                    editCategory.categoryImg.value.toString(),
                                    widget.categoriesModel.categoryId);
                                EasyLoading.dismiss();
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
                      )
                    : const SizedBox.shrink();
              },
            ),

            //
            const SizedBox(height: 10.0),
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
                  hintText: "Product Name",
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
                CategoryModel categoriesModel = CategoryModel(
                  categoryId: widget.categoriesModel.categoryId,
                  categoryName: categoryNameController.text.trim(),
                  categoryImg: widget.categoriesModel.categoryImg,
                  createdAt: widget.categoriesModel.createdAt,
                  updatedAt: DateTime.now(),
                );

                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoriesModel.categoryId)
                    .update(categoriesModel.toMap());

                EasyLoading.dismiss();
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
