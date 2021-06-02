import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';

import 'home.dart';
import 'tabs/conversation/tab_conversation_controller.dart';
import 'tabs/user/tab_user_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(provider: UserProvider()));
    Get.lazyPut(() => TabConversationController(provider: ChatProvider()));
    Get.lazyPut(() => TabUserController(provider: UserProvider()));
  }
}
