import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdteam_demo_chat/app/data/models/message.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';

class ChatController extends GetxController {
  final ChatProvider provider;

  ChatController({required this.provider});

  final textController = TextEditingController();
  final _isLoading = true.obs;
  final _messages = <Message>[].obs;
  var dateTime = ''.obs;

  get isLoading => _isLoading.value;

  set isLoading(value) {
    _isLoading.value = value;
  }

  List<Message> get messages => _messages.value;

  set messages(value) {
    _messages.value = value;
  }

  @override
  void onInit() async {
    provider.getMessages(Get.arguments['uID'])
      ..listen((event) {
        // messages = event;
        var grByDate = groupBy<Message, String>(event, (message) {
          DateTime time = DateTime.parse(message.createdAt);
          return '${time.day}/${time.month}/${time.year}';
        });
        grByDate.forEach((date, list) {
          dateTime.value = date;
          print('$date');
          messages = list;
          // list.forEach((listItem) {
          //   print('${listItem.createdAt}');
          // });
        });
      // grouped = grByDate;
      // print(grouped);
      });
    isLoading = false;
    super.onInit();
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      provider.sendMessage(Message(
        message: textController.text,
        senderUID: FirebaseAuth.instance.currentUser!.uid,
        receiverUID: Get.arguments['uID'],
        createdAt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      ));
      textController.clear();
    }
  }
}
