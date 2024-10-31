// ignore_for_file: must_be_immutable

import 'package:ecom/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckSingleOrderScreen extends StatelessWidget {
  String docId;
  OrderModel orderModel;
  CheckSingleOrderScreen({
    super.key,
    required this.docId,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
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
                    foregroundImage: NetworkImage(orderModel.productImages[0]),
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
              child: Text("Product Name: " + orderModel.productName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Product Id: " + orderModel.productId.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Total Order Price: " +
                  orderModel.productTotalPrice.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Product Quantity: x" +
                  orderModel.productQuantity.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Category Name: " + orderModel.categoryName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("On Sale? : " + orderModel.isSale.toString()),
            ),
            Divider(
              indent: 30.0,
              endIndent: 30.0,
              thickness: 0.7,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Customer Id: " + orderModel.customerId),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Customer Name: " + orderModel.customerName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Customer Phone: " + orderModel.customerPhone),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Customer Address: " + orderModel.customerAddress),
            ),
          ],
        ),
      ),
    );
  }
}
