// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/services/generate_random_id_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../admin-controllers/admin_cattegory_dropdown_controller.dart';
import '../admin-controllers/admin_isSale_controller.dart';
import '../admin-controllers/admin_product_images_controller.dart';
import '../admin-widget/admin_drop_down_category_widget.dart';
import 'admin_all_products_screen.dart';

class AddProductsScreen extends StatelessWidget {
  AddProductsScreen({super.key});

  AddProductImagesController addProductImagesController =
      Get.put(AddProductImagesController());
  CattegoryDropdownController cattegoryDropdownController =
      Get.put(CattegoryDropdownController());
  IsSaleController isSaleController = Get.put(IsSaleController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliverytimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Products"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select images"),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.ShowImagesPickerDialog();
                      },
                      child: Text("Select Images"),
                    ),
                  ],
                ),
              ),

              //Show Images
              GetBuilder<AddProductImagesController>(
                init: AddProductImagesController(),
                builder: (imageController) {
                  return imageController.selectedImages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                              itemCount: imageController.selectedImages.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (BuildContext context, index) {
                                return Stack(
                                  children: [
                                    Image.file(
                                      File(addProductImagesController
                                          .selectedImages[index].path
                                          .toString()),
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
                                        },
                                        child: CircleAvatar(
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
                              }),
                        )
                      : SizedBox.shrink();
                },
              ),

              //Show categories drop down
              DropDownCategoriesWiidget(),
              //On Sale?
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Is Sale"),
                          Switch(
                            value: isSaleController.isSale.value,
                            onChanged: (value) {
                              isSaleController.toggleisSale(value);
                            },
                            activeColor: Colors.amber,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

              //form
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
              SizedBox(
                height: 10.0,
              ),
              Obx(
                () {
                  return isSaleController.isSale.value
                      ? Container(
                          height: 65,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: salePriceController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              hintText: "Sale Price",
                              hintStyle: TextStyle(fontSize: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Full Price",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: deliverytimeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Delivery Time",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "Product Description",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (productNameController.text.isEmpty ||
                        fullPriceController.text.isEmpty ||
                        productDescriptionController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details..",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.amber,
                        colorText: Colors.black,
                      );
                    } else if (isSaleController.isSale.value == true &&
                        salePriceController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details..",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.amber,
                        colorText: Colors.black,
                      );
                    } else {
                      try {
                        EasyLoading.show();
                        await addProductImagesController.uploadFunction(
                            addProductImagesController.selectedImages);
                        String productId =
                            await GenerateProductIds().generateProductId();

                        ProductModel productModel = ProductModel(
                          productId: productId,
                          categoryId: cattegoryDropdownController
                              .selectedCategoryId
                              .toString(),
                          productName: productNameController.text.trim(),
                          categoryName: cattegoryDropdownController
                              .selectedCategoryName
                              .toString(),
                          salePrice: salePriceController.text != ''
                              ? salePriceController.text.trim()
                              : '',
                          fullPrice: fullPriceController.text.trim(),
                          productImages:
                              addProductImagesController.arrImagesUrl,
                          deliveryTime: deliverytimeController.text.trim(),
                          isSale: isSaleController.isSale.value,
                          productDescription:
                              productDescriptionController.text.trim(),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(productId)
                            .set(productModel.toMap());
                        EasyLoading.dismiss();
                        Get.snackbar(
                          "Success",
                          "Successfully added the product.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.amber,
                          colorText: Colors.black,
                        );
                        Get.offAll(() => AdminAllProductsScreen());
                      } catch (e) {
                        EasyLoading.dismiss();
                        print("Error: $e");
                      }
                    }
                  },
                  child: Text("Upload")),
            ],
          ),
        ),
      ),
    );
  }
}
