import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../controllers/cart_price_controller.dart';
import '../controllers/get_customer_device_token_controller.dart';
import '../services/place_order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  TextEditingController namecontroller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? customerToken;
  String? name;
  String? phone;
  String? address;

  Razorpay _razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Checkout Screen'),
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
                                Text("Product Quantity: x" +
                                    cartModel.productQuantity.toString()),
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
              padding: const EdgeInsets.all(9.0),
              child: SizedBox(
                width: Get.width / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    showCustomBottomBar();
                  },
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomBar() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: namecontroller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (namecontroller.text != '' &&
                        phoneController.text != '' &&
                        addressController.text != '') {
                      var options = {
                        'key': 'rzp_test_YghCO1so2pwPnx',
                        'amount': '1000',
                        'currency': 'PKR',
                        'name': namecontroller.text.trim(),
                        'description': '',
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        }
                      };
                      _razorpay.open(options);
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please enter all details",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.amber,
                        colorText: Colors.black,
                      );
                    }
                  },
                  child: Text("Place order"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6.0,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //Place order service
    String name = namecontroller.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();

    String customerToken = await GetCustomerDeviceToken();
    placeOrder(
      context: context,
      customerName: name,
      customerPhone: phone,
      customerAddress: address,
      customerDeviceToken: customerToken,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
