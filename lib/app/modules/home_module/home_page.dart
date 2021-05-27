import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: GetX<HomeController>(
          builder: (_) {
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) {
                final item = controller.users[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.chat, arguments: {
                        'uID': item.uID,
                        'name': item.name,
                        'avatar': item.avatar,
                        'isActive': item.isActive,
                      });
                    },
                    leading: WidgetAvatar(
                      url: item.avatar,
                      isActive: item.isActive,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name),
                        Text(
                          item.email,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
