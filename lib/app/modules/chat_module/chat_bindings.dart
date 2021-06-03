import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

import 'chat.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(
          provider: ChatProvider(),
          storageProvider: StorageProvider(),
        ));
  }
}
