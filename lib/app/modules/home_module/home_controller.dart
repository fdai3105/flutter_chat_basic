import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/message.dart';
import 'package:pdteam_demo_chat/app/data/models/user.dart' as MyUser;
import 'package:pdteam_demo_chat/app/data/provider/auth_provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final UserProvider provider;

  HomeController({required this.provider});

  final _isLoading = true.obs;
  final _users = <MyUser.MyUser>[].obs;
  final _lastMessages = <Message>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser.MyUser> get users => _users.value;

  set users(value) {
    _users.value = value;
  }

  List<Message> get lastMessages => _lastMessages.value;

  set lastMessages(value) {
    _lastMessages.value = value;
  }

  @override
  void onInit() async {
    UserProvider().changeActive(true);
    WidgetsBinding.instance!.addObserver(this);
    await provider.getListUsers()..listen((event) => users = event);
    isLoading = false;
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        UserProvider().changeActive(true);
        break;
      case AppLifecycleState.inactive:
        UserProvider().changeActive(false);
        break;
      case AppLifecycleState.detached:
        UserProvider().changeActive(false);
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void logout() {
    AuthProvider.logout();
    Get.offAllNamed(Routes.login);
  }
}
