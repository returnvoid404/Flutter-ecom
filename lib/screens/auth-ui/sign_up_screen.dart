// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import, sort_child_properties_last

import 'package:ecom/controllers/sign_up_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //adding controller to the screen
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController useremail = TextEditingController();
  TextEditingController userpassword = TextEditingController();
  TextEditingController userphone = TextEditingController();
  // var confirmPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        // bottom: PreferredSize(
        //     child: Text(
        //       "Bee-lieve in Better Shopping!",
        //       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        //     ),
        //     preferredSize: Size.square(22)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            top: 56.0,
            left: 24.0,
            right: 24.0,
            bottom: 24.0,
          ),
          child: Column(
            children: [
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      //Email
                      TextFormField(
                        controller: useremail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.envelope),
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

                      //Name
                      TextFormField(
                        controller: username,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.person),
                            hintText: 'Username',
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

                      //Phone
                      TextFormField(
                        controller: userphone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.phone),
                            hintText: 'Phone',
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

                      //Password
                      Obx(
                        () => TextFormField(
                          controller: userpassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: signUpController.ispasswordvisible.value,
                          decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.padlock),
                              hintText: 'Password',
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    signUpController.ispasswordvisible.toggle();
                                  },
                                  child: signUpController
                                          .ispasswordvisible.value
                                      ? Icon(CupertinoIcons.eye_fill)
                                      : Icon(CupertinoIcons.eye_slash_fill)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                10.0,
                              )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: (Colors.amber[300])!,
                              ))),
                        ),

                        // validator: (String? value) {
                        //   confirmPass = value;
                        //   if (value!.isEmpty) {
                        //     return "Please enter new password";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),

                      const SizedBox(
                        height: 30.00,
                      ),

                      // //Confirm Password
                      // TextFormField(
                      //     keyboardType: TextInputType.visiblePassword,
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //         prefixIcon: Icon(CupertinoIcons.padlock),
                      //         hintText: 'Confirm Password',
                      //         suffixIcon: Icon(CupertinoIcons.eye_fill),
                      //         border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(
                      //           10.0,
                      //         )),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //           color: (Colors.amber[300])!,
                      //         ))),
                      //     validator: (String? value) {
                      //       if (value!.isEmpty) {
                      //         return "Please Re-Enter New Password";
                      //       } else if (value != confirmPass) {
                      //         return "Password must be same as above";
                      //       } else {
                      //         return null;
                      //       }
                      //     }
                      //     ),

                      // const SizedBox(
                      //   height: 30.00,
                      // ),

                      //Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            String name = username.text.trim();
                            String email = useremail.text.trim();
                            String phone = userphone.text.trim();
                            String password = userpassword.text.trim();
                            String userdevicetoken = '';

                            if (name.isEmpty ||
                                email.isEmpty ||
                                phone.isEmpty ||
                                password.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter all details..",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.amber,
                                colorText: Colors.black,
                              );
                            } else {
                              UserCredential? usercredential =
                                  await signUpController.SignUpMethod(
                                name,
                                email,
                                phone,
                                password,
                                userdevicetoken,
                              );
                              if (usercredential != null) {
                                Get.snackbar(
                                  "Verification E-Mail sent.",
                                  "Please check your inbox, and don't forget to check spam aswell.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.amber,
                                  colorText: Colors.black,
                                );

                                FirebaseAuth.instance.signOut();
                                Get.offAll(() => LogInScreen());
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Please try again",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.amber,
                                  colorText: Colors.black,
                                );
                              }
                            }
                          },
                          child: Text("Sign Up"),
                        ),
                      ),
                      const SizedBox(
                        height: 16.00,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Sign In Redirect
                          TextButton(
                            onLongPress: () {},
                            onPressed: () => Get.offAll(() => LogInScreen()),
                            child:
                                const Text("Already have an account? Sign In",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                          )
                        ],
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
