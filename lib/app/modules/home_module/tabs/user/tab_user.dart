import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user_controller.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class UserTab extends GetView<TabUserController> {
  const UserTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetAppBar(title: 'User'),
      body: SafeArea(
        child: GetX<TabUserController>(
          builder: (_) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) {
                final item = controller.users[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.chat, arguments: {
                        'uID': null,
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
