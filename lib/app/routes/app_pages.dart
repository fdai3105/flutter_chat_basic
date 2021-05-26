import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat_page.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home_page.dart';

import '../../app/modules/login_module/login_bindings.dart';
import '../../app/modules/login_module/login_page.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
  ];
}
