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
  final _selected = <String>[].obs;
  final _listUser = <MyUser>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<MyUser> get users => _users;

  set users(value) {
    _users.value = value;
  }

  List<String> get selected => _selected;

  set selected(value) {
    _selected.value = value;
  }

  List<MyUser> get listUser => _listUser;

  set listUser(value) {
    _listUser.value = value;
  }

  @override
  void onInit() async {
    users = await userProvider.getUsers();
    isLoading = false;
    super.onInit();
  }

  void onSelect(String uid, token) {
    if (selected.contains(uid)) {
      selected.removeWhere((element) => element == uid);
    } else {
      selected.add(uid);
    }
  }

  void listSelect(item) {
    if (listUser.contains(item)) {
      listUser.removeWhere((element) => element == item);
    } else {
      listUser.add(item);
    }
  }

  Future onSubmit() async {
    await provider.createGroupChat(selected, textCtrl.text);
    Get.back();
  }
}
