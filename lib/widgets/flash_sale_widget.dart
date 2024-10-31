import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/user-panel/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get(),
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
            height: Get.height / 4.0,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productdata = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
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
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetailScreen(productModel: productModel)),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: MediaQuery.of(context).size.width * 0.30,
                            heightImage:
                                MediaQuery.of(context).size.height * 0.1,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            footer: Row(
                              children: [
                                Text(
                                  "Rs ${productModel.salePrice}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "${productModel.fullPrice}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
