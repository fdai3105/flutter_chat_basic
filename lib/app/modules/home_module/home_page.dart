import 'package:flutter/material.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: 'Home'),
      body: SafeArea(
        child: GetX<HomeController>(
          builder: (_) {
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) {
                final item = controller.users[i];
                return ListTile(
                  title: Text(item.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
