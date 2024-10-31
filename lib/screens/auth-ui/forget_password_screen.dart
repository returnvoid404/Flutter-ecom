import 'package:ecom/controllers/forget_password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final ForgetPassController forgetPassController =
      Get.put(ForgetPassController());
  TextEditingController useremail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text(
          //   'Sign Up',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 56.0,
            left: 24.0,
            right: 24.0,
            bottom: 24.0,
          ),
          child: Column(
            children: [
              const Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/logoextended.png'),
                    height: 150,
                  ),
                  Text(
                    "Find your account.",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      const Text(
                        "Please enter your email address to search for your account.",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      //Email
                      TextFormField(
                        controller: useremail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(CupertinoIcons.envelope),
                            hintText: 'E-Mail',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              10.0,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: (Colors.amber[300])!,
                            ))),
                      ),
                      const SizedBox(
                        height: 16.00,
                      ),

                      //Account search button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            String email = useremail.text.trim();

                            if (email.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter all details",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.amber,
                                colorText: Colors.black,
                              );
                            } else {
                              String email = useremail.text.trim();
                              forgetPassController.ForgetPassMethod(email);
                            }
                          },
                          child: const Text("Search"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
