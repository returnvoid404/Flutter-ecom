// ignore_for_file: must_be_immutable

import 'package:ecom/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProductDetailScreen extends StatelessWidget {
  ProductModel productModel;
  AdminProductDetailScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: Get.width / 3,
                  ),
                  CircleAvatar(
                    radius: 60,
                    foregroundImage:
                        NetworkImage(productModel.productImages[0]),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30.0,
              endIndent: 30.0,
              thickness: 0.7,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Product Name: " + productModel.productName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Product Id: " + productModel.productId.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("Average Delivery Time: " + productModel.deliveryTime),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("On Sale? : " + productModel.isSale.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
