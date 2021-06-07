import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home_page.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_bindings.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_page.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialBinding: FirebaseAuth.instance.currentUser != null
          ? HomeBinding()
          : LoginBinding(),
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : LoginPage(),
    ),
  );
}
