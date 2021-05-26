import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/widgets/widget_appbar.dart';

class ChatPage extends GetView<ChatController>{
  final String name;

  ChatPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(title: name),
    );
  }

}