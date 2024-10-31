import 'package:ecom/user-panel/all_categories_screen.dart';
import 'package:ecom/user-panel/all_flash_sale_products_screen.dart';
import 'package:ecom/user-panel/all_products_screen.dart';
import 'package:ecom/user-panel/cart_screen.dart';
import 'package:ecom/widgets/all_products_widget.dart';
import 'package:ecom/widgets/banner_widget.dart';
import 'package:ecom/widgets/category_widget.dart';
import 'package:ecom/widgets/flash_sale_widget.dart';
import 'package:ecom/widgets/heading_widget.dart';
import 'package:ecom/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beez Bag'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart_outlined),
            ),
          )
        ],
      ),
      //Sidebar
      drawer: SideMenuWidget(),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
              //Banners
              BannerWidget(),

              //Heading
              HeadingWidget(
                headingtitle: "Categories",
                headingsubtitle: "For you",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttontext: "See More >",
              ),
              //Category
              CattegoryWidget(),
              //Heading
              HeadingWidget(
                headingtitle: "Flash Sales",
                headingsubtitle: "Top picks",
                onTap: () => Get.to(() => AllFlashSaleProductsScreen()),
                buttontext: "See More >",
              ),
              //Flash sale
              FlashSaleWidget(),
              //Heading
              HeadingWidget(
                headingtitle: "All Products",
                headingsubtitle: "Explore our curated selection of products.",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttontext: "See More >",
              ),
              AllPorductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
