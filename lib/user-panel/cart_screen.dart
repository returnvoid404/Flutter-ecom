import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:ecom/user-panel/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../controllers/cart_price_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Cart Screen'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
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
                      CartModel cartModel = CartModel(
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
                      );

                      //Calculate Price
                      productPriceController.fetchProductPrice();

                      return SwipeActionCell(
                        key: ObjectKey(cartModel.productId),
                        trailingActions: [
                          SwipeAction(
                            title: "Delete",
                            forceAlignmentToBoundary: true,
                            performsFirstActionWithFullSwipe: true,
                            onTap: (CompletionHandler handler) async {
                              await FirebaseFirestore.instance
                                  .collection('cart')
                                  .doc(user!.uid)
                                  .collection('cartOrders')
                                  .doc(cartModel.productId)
                                  .delete();
                            },
                          )
                        ],
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(cartModel.productImages[0]),
                            ),
                            title: Text(cartModel.productName),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(cartModel.productTotalPrice.toString()),
                                SizedBox(
                                  width: Get.width / 20.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (cartModel.productQuantity > 1) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1,
                                        'productTotalPrice': cartModel.isSale ==
                                                    true &&
                                                cartModel.salePrice != ''
                                            ? double.parse(
                                                    cartModel.salePrice) *
                                                (cartModel.productQuantity - 1)
                                            : double.parse(
                                                    cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1)
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    child: Text("-"),
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width / 20.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (cartModel.productQuantity > 0) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity + 1,
                                        'productTotalPrice': cartModel.isSale ==
                                                    true &&
                                                cartModel.salePrice != ''
                                            ? double.parse(
                                                    cartModel.salePrice) +
                                                double.parse(
                                                        cartModel.salePrice) *
                                                    (cartModel.productQuantity)
                                            : double.parse(
                                                    cartModel.fullPrice) +
                                                double.parse(
                                                        cartModel.fullPrice) *
                                                    (cartModel.productQuantity)
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    child: Text("+"),
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width / 20.0,
                                ),
                                Text(
                                  "Product Quantity: x" +
                                      cartModel.productQuantity.toString(),
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          }

          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        // margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Text(
                    "Rs " +
                        productPriceController.totalprice.value
                            .toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Get.to(() => CheckoutScreen());
                  },
                  child: Text("Checkout"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
