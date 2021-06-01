import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user_controller.dart';

class TabUserBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabUserController(provider: UserProvider()));
  }
}
