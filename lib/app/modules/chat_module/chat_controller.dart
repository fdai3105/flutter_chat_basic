import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';

class ChatController extends GetxController {
  final ChatProvider provider;

  ChatController({required this.provider});

  final textController = TextEditingController();

  final _isLoading = true.obs;
  final _messages = <Message>[].obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<Message> get messages => _messages;

  set messages(value) {
    _messages.value = value;
  }

  @override
  void onInit() async {
    provider.getMessages(Get.arguments['uID'])
      ..listen((event) {
        messages = event;
      });
    isLoading = false;
    super.onInit();
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      provider.sendMessage(
          Get.arguments['uID'],
          Message(
            message: textController.text,
            senderUID: FirebaseAuth.instance.currentUser!.uid,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ));
      textController.clear();
    }
  }
}
