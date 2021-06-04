import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/group_chat_provider.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

class CreateGroupChatController extends GetxController {
  final GroupChatProvider provider;
  final UserProvider userProvider;

  CreateGroupChatController({
    required this.provider,
    required this.userProvider,
  });

  final textCtrl = TextEditingController();

  final _isLoading = true.obs;
  final _users = <MyUser>[].obs;
  final _selected = <MyUser>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser> get users => _users;

  set users(value) {
    _users.value = value;
  }

  List<MyUser> get selected => _selected;

  set selected(value) {
    _selected.value = value;
  }

  @override
  void onInit() async {
    users = await userProvider.getUsers();
    selected.add(MyUser(
        uid: UserProvider.getCurrentUser()!.uid,
        avatar: UserProvider.getCurrentUser()!.photoURL,
        name: 'You',
        email: UserProvider.getCurrentUser()!.email ?? '',
        isActive: false));
    isLoading = false;
    super.onInit();
  }

  void onSelect(MyUser item) {
    if (selected.contains(item)) {
      selected.removeWhere((element) => element == item);
    } else {
      selected.add(item);
    }
  }

  Future onSubmit() async {
    await provider.createGroupChat(
      selected.map((e) => e.uid).toList(),
      textCtrl.text,
    );
    Get.back();
  }
}
