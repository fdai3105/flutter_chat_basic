import '../../app/modules/create_group_chat_module/create_group_chat_page.dart';
import '../../app/modules/create_group_chat_module/create_group_chat_bindings.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat_page.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/home_page.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/conversation/tab_conversation.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/conversation/tab_conversation_bindings.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user_bindings.dart';

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
    GetPage(
      name: Routes.tabChat,
      page: () => ConversationTab(),
      binding: TabConversationBindings(),
    ),
    GetPage(
      name: Routes.tabUser,
      page: () => UserTab(),
      binding: TabUserBindings(),
    ),
    GetPage(
      name: Routes.createGroupChat,
      page: () => CreateGroupChatPage(),
      binding: CreateGroupChatBinding(),
    ),
  ];
}
