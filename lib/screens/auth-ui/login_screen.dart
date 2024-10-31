// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import, unnecessary_null_comparison

import 'package:ecom/controllers/google_signin_controller.dart';
import 'package:ecom/controllers/log_in_controller.dart';
import 'package:ecom/controllers/user_data_controller.dart';
import 'package:ecom/screens/admin-panel/admin_home_screen.dart';
import 'package:ecom/screens/auth-ui/forget_password_screen.dart';
import 'package:ecom/screens/auth-ui/sign_up_screen.dart';
import 'package:ecom/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //declaring controllers used in this files
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final LogInController logInController = Get.put(LogInController());
  final UserDataController userDataController = Get.put(UserDataController());

  //controllers for text box
  TextEditingController useremail = TextEditingController();
  TextEditingController userpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/logoextended.png'),
                    height: 150,
                  ),
                  Text(
                    "Where Shopping Takes Flight!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
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

                      //Password
                      Obx(
                        () => TextFormField(
                          controller: userpassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: logInController.ispasswordvisible.value,
                          decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.padlock),
                              hintText: 'Password',
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    logInController.ispasswordvisible.toggle();
                                  },
                                  child: logInController.ispasswordvisible.value
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
                      ),
                      const SizedBox(
                        height: 8.00,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Forget Password
                          TextButton(
                              onPressed: () {
                                Get.to(() => ForgetPassScreen());
                              },
                              child: const Text("Forget Password?",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )))
                        ],
                      ),
                      const SizedBox(
                        height: 16.00,
                      ),

                      //Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            String email = useremail.text.trim();
                            String password = userpassword.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter all details",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.amber,
                                colorText: Colors.black,
                              );
                            } else {
                              UserCredential? usercredential =
                                  await LogInController()
                                      .LogInMethod(email, password);

                              var userdata = await userDataController
                                  .userdata(usercredential!.user!.uid);

                              if (usercredential != null) {
                                if (usercredential.user!.emailVerified) {
                                  if (userdata[0]['isAdmin'] == true) {
                                    Get.offAll(() => AdminHomeScreen());
                                    Get.snackbar(
                                      "Admin login success.",
                                      "Logging you in.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.amber,
                                      colorText: Colors.black,
                                    );
                                  } else {
                                    Get.offAll(() => Home());
                                    Get.snackbar(
                                      "Success",
                                      "Logging you in.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.amber,
                                      colorText: Colors.black,
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Please verify email before logging in",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.amber,
                                    colorText: Colors.black,
                                  );
                                }
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
                          child: Text("Sign In"),
                        ),
                      ),
                      const SizedBox(
                        height: 16.00,
                      ),

                      //Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onLongPress: () {},
                          onPressed: () => Get.to(() => SignUpScreen()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber,
                            side: BorderSide(
                                width: 1.5, color: (Colors.amber[300])!),
                          ),
                          child: Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: Colors.black45,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    "Or Sign In With",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                  Flexible(
                    child: Divider(
                      color: Colors.black45,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26.00,
              ),

              //Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                      onPressed: () {
                        _googleSignInController.signinwithgoogle();
                      },
                      icon: const Image(
                          width: 24.0,
                          height: 24.0,
                          image: AssetImage('assets/images/google.png')),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
