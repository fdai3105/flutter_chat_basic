import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

import 'tab_conversation_controller.dart';

class TabConversationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabConversationController(provider: ChatProvider()));
  }
}
