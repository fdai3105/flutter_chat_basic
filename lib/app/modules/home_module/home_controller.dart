import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'tabs/conversation/tab_conversation.dart';
import 'tabs/user/tab_user.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final UserProvider provider;

  HomeController({required this.provider});

  final _currentTab = 0.obs;

  int get currentTab => _currentTab.value;

  set currentTab(int value) {
    _currentTab.value = value;
  }

  final items = [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.chat),
      title: 'Chats',
      activeColorPrimary: Colors.green,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.person),
      title: 'User',
      activeColorPrimary: Colors.green,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];

  final tabs = [
    ConversationTab(),
    UserTab(),
  ];

  @override
  void onInit() async {
    UserProvider().changeActive(true);
    WidgetsBinding.instance!.addObserver(this);
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
}
