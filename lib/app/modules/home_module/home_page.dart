import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: 'Home'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetX<HomeController>(
          builder: (_) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, i) {
                final item = controller.users[i];
                return ListTile(
                  leading: Image.network(item.avatar ?? ''),
                  title: Text(item.name),
                  subtitle: Text(item.email),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
