import 'package:ecom/screens/admin-panel/admin-widget/admin_side_menu_widget.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      drawer: AdminSideMenuWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "An impressive e-commerce prototype app using Flutter, combining functionality and aesthetics for a seamless shopping experience.(Made by Sami Hussain)"),
        ),
      ),
    );
  }
}
