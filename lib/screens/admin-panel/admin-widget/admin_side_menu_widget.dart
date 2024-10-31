import 'package:ecom/screens/admin-panel/admin-screens/admin_all_orders_screen.dart';
import 'package:ecom/screens/admin-panel/admin-screens/admin_all_products_screen.dart';
import 'package:ecom/screens/admin-panel/admin-screens/admin_all_users_screen.dart';
import 'package:ecom/screens/admin-panel/admin_home_screen.dart';
import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../admin-screens/admin_all_categories_screen.dart';

class AdminSideMenuWidget extends StatefulWidget {
  const AdminSideMenuWidget({super.key});

  @override
  State<AdminSideMenuWidget> createState() => _AdminSideMenuWidgetState();
}

class _AdminSideMenuWidgetState extends State<AdminSideMenuWidget> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    firebaseAuth.currentUser!.email.toString(),
                  ),
                  subtitle: Text("Version 1.0.0"),
                  leading: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Colors.amber,
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              Divider(
                indent: 10.0,
                endIndent: 10.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () {
                    Get.back();
                    Get.offAll(() => AdminHomeScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Home"),
                  leading: Icon(CupertinoIcons.home),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () {
                    Get.to(() => AllUsersScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Users"),
                  leading: Icon(CupertinoIcons.person),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () {
                    Get.to(() => AllOrdersScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Orders"),
                  leading: Icon(CupertinoIcons.bag),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () {
                    Get.to(() => AdminAllProductsScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Products"),
                  leading: Icon(CupertinoIcons.shopping_cart),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () {
                    Get.to(() => AdminAllCategoriesScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Categories"),
                  leading: Icon(CupertinoIcons.chart_pie_fill),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListTile(
                  onTap: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await firebaseAuth.signOut();
                    await googleSignIn.signOut();
                    Get.offAll(() => const LogInScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Logout"),
                  leading: Icon(CupertinoIcons.arrow_left_to_line),
                ),
              ),
              Divider(
                indent: 30.0,
                endIndent: 30.0,
                thickness: 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
