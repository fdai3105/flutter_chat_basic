import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/chat/tab_chat_controller.dart';

class TabChatBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabChatController(provider: ChatProvider()));
  }
}
