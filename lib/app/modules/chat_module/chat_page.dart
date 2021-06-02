import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/widgets/widgets.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class ChatPage extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetX<ChatController>(
                builder: (_) {
                  if (controller.messages.isEmpty) {
                    return SizedBox();
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, i) {
                      final item = controller.messages[i];
                      return WidgetBubble(
                        dateTime:
                            '${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.createdAt))}',
                        avatar: item.sender.avatar,
                        message: item.message,
                        isMe: item.senderUID ==
                            FirebaseAuth.instance.currentUser!.uid,
                      );
                    },
                  );
                },
              ),
            ),
            WidgetInputField(
              controller: controller.textController,
              onSubmit: () => controller.sendMessage(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      title: Row(
        children: [
          WidgetAvatar(
            url: Get.arguments['avatar'],
            isActive: Get.arguments['isActive'],
            size: 40,
          ),
          SizedBox(width: 12),
          Text(
            Get.arguments['name'],
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    );
  }
}

class WidgetInputField extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? onSubmit;

  const WidgetInputField({
    Key? key,
    required this.controller,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter Message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onSubmit,
            icon: Icon(
              Icons.send,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
