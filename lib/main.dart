import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_bindings.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_page.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      getPages: AppPages.pages,
      initialBinding: LoginBinding(),
      home: LoginPage(),
    );
  }
}
