import 'package:ecom/screens/auth-ui/login_screen.dart';
import 'package:ecom/screens/home.dart';
import 'package:ecom/user-panel/all_orders_screen.dart';
import 'package:ecom/user-panel/all_products_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
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
                    Get.to(() => Home());
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
                    Get.back();
                    Get.to(() => AllProductsScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Store "),
                  leading: Icon(CupertinoIcons.tag),
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
                    Get.back();
                    Get.to(() => OrdersScreen());
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
