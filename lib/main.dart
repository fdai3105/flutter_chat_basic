import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home_page.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_bindings.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_page.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  var isLogin = _prefs.getBool('isLogin');
  print(isLogin);
  runApp(
      GetMaterialApp(
        title: 'Flutter Demo',
        getPages: AppPages.pages,
        initialBinding: isLogin != null ? HomeBinding() : LoginBinding(),
        home: isLogin != null ? HomePage() : LoginPage(),
      )
  );
}
