import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PersistentTabView(
          context,
          screens: controller.tabs,
          items: controller.items,
          popActionScreens: PopActionScreensType.all,
          navBarStyle: NavBarStyle.style12,
        ),
      ),
    );
  }
}
