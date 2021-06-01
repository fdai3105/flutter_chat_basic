import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'User',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetAppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Navigator(
          key: Get.nestedKey(1),
          initialRoute: Routes.tabChat,
          onGenerateRoute: controller.onGenerateRoute,
        ),
      ),
      bottomNavigationBar: GetX<HomeController>(
        builder: (_) {
          return BottomNavigationBar(
            items: items,
            currentIndex: controller.currentTab,
            onTap: controller.changePage,
          );
        },
      ),
    );
  }
}
