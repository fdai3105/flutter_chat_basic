import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/modules/create_group_chat_module/create_group_chat_controller.dart';

class CreateGroupChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateGroupChatController(
          provider: GroupChatProvider(),
          userProvider: UserProvider(),
        ));
  }
}
