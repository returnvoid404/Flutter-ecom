import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_price_controller.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('All orders'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No prodcuts found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productdata = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel(
                    productId: productdata['productId'],
                    categoryId: productdata['categoryId'],
                    productName: productdata['productName'],
                    categoryName: productdata['categoryName'],
                    salePrice: productdata['salePrice'],
                    fullPrice: productdata['fullPrice'],
                    productImages: productdata['productImages'],
                    deliveryTime: productdata['deliveryTime'],
                    isSale: productdata['isSale'],
                    productDescription: productdata['productDescription'],
                    createdAt: productdata['createdAt'],
                    updatedAt: DateTime.now(),
                    productQuantity: productdata['productQuantity'],
                    productTotalPrice: productdata['productTotalPrice'],
                    customerId: productdata['customerId'],
                    status: productdata['status'],
                    customerName: productdata['customerName'],
                    customerPhone: productdata['customerPhone'],
                    customerAddress: productdata['customerAddress'],
                    customerDeviceToken: productdata['customerDeviceToken'],
                  );

                  //Calculate Price
                  productPriceController.fetchProductPrice();

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(orderModel.productImages[0]),
                      ),
                      title: Text(orderModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(orderModel.productTotalPrice.toString()),
                          SizedBox(
                            width: 10.0,
                          ),
                          orderModel.status != true
                              ? Text(
                                  "Pending..",
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text("Delivered.",
                                  style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
