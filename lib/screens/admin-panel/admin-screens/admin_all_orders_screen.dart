import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/screens/admin-panel/admin-controllers/admin_get_all_users_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_specific_cutomer_order_screen.dart';

class AllOrdersScreen extends StatelessWidget {
  AllOrdersScreen({super.key});
  final GetAllUsersController getAllUsersController =
      Get.put(GetAllUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('creatdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching category!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No orders found!'),
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () => SpecificCustomerOrderScreen(
                          docId: snapshot.data!.docs[index]['uId'],
                          customerName: snapshot.data!.docs[index]
                              ['cutomerName']),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(data['cutomerName'][0]),
                    ),
                    title: Text(data['cutomerName']),
                    subtitle: Text(data['customerPhone']),
                    trailing: Icon(Icons.edit),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
