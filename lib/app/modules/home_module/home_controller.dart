import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/user.dart' as MyUser;
import 'package:pdteam_demo_chat/app/data/provider/user_provider.dart';
import 'package:pdteam_demo_chat/app/routes/app_pages.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final UserProvider provider;

  HomeController({required this.provider});

  final _isLoading = true.obs;
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

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.login);
  }
}
