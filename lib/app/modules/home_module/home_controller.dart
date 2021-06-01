import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart' as MyUser;
import 'package:pdteam_demo_chat/app/data/provider/auth_provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/chat/tab_chat.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/chat/tab_chat_bindings.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user.dart';
import 'package:pdteam_demo_chat/app/modules/home_module/tabs/user/tab_user_bindings.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final UserProvider provider;

  HomeController({required this.provider});

  final _isLoading = true.obs;
  final _currentTab = 0.obs;

  int get currentTab => _currentTab.value;

  set currentTab(int value) {
    _currentTab.value = value;
  }

  final _users = <MyUser.MyUser>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser.MyUser> get users => _users.value;

  set users(value) {
    _users.value = value;
  }

  @override
  void onInit() async {
    UserProvider().changeActive(true);
    WidgetsBinding.instance!.addObserver(this);
    provider.getListUsers().listen((event) {
      users = event;
    });
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

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.tabChat)
      return GetPageRoute(
        settings: settings,
        page: () => ChatTab(),
        binding: TabChatBindings(),
      );

    if (settings.name == Routes.tabUser)
      return GetPageRoute(
        settings: settings,
        page: () => UserTab(),
        binding: TabUserBindings(),
      );
  }

  final pages = [Routes.tabChat, Routes.tabUser];

  void changePage(int index) {
    currentTab = index;
    Get.toNamed(pages[index], id: 1);
  }

  void logout() {
    AuthProvider.logout();
    Get.offAllNamed(Routes.login);
  }
}
