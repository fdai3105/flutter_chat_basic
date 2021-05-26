import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';

import 'chat.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(provider: ChatProvider()));
  }
}
