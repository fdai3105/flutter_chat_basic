import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/login_module/login_controller.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: 'Login'),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
        ],
      ),
    );
  }
}
