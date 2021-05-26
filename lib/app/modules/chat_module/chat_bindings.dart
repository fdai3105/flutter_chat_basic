import 'package:get/get.dart';
import 'chat.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}