import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';

import 'home.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
        provider: UserProvider()));
  }
}
