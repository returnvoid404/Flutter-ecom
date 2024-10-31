// ignore_for_file: prefer_const_constructors

import 'package:ecom/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'screens/auth-ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lato',
      // Set Lato as the default app font.
      theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.amber)),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
