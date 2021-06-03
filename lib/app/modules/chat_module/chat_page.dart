import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/chat.dart';
import 'package:pdteam_demo_chat/app/modules/chat_module/widgets/widgets.dart';
import 'package:pdteam_demo_chat/app/widgets/widgets.dart';

class ChatPage extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => controller.onBackPress(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: WidgetAppBar(
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
        ),
        body: Column(
          children: [
            Expanded(
              child: GetX<ChatController>(
                builder: (_) {
                  if (controller.messages.isEmpty) {
                    return SizedBox();
                  }
                  return ListView.builder(
                    controller: controller.listScrollController,
                    reverse: true,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, i) {
                      final item = controller.messages[i];
                      return WidgetBubble(
                          dateTime:
                              '${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.createdAt))}',
                          message: item.message,
                          isMe: item.senderUID ==
                              FirebaseAuth.instance.currentUser!.uid,
                          type: item.type);
                    },
                  );
                },
              ),
            ),
            WidgetInputField(
              controller: controller.textController,
              scrollController: controller.listScrollController,
              onSubmit: () => controller.sendMessage(0, null),
              sendIcon: () {
                controller.emojiShowing = !controller.emojiShowing;
              },
              sendImage: () {
                controller.sendImage();
              },
              isEmojiVisible: controller.emojiShowing,
              isKeyboardVisible: controller.isKeyboardVisible,
            ),
            GetX<ChatController>(builder: (_) {
              return Offstage(
                offstage: !controller.emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        controller.onEmojiSelected(emoji);
                      },
                      onBackspacePressed: () {
                        controller.onBackspacePressed();
                      },
                      config: const Config(
                          columns: 7,
                          emojiSizeMax: 32.0,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: 'No Recents',
                          noRecentsStyle:
                              TextStyle(fontSize: 20, color: Colors.black26),
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class WidgetInputField extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController? scrollController;
  final Function()? onSubmit;
  final Function()? sendIcon;
  final Function()? sendImage;
  final bool isKeyboardVisible;
  final bool isEmojiVisible;
  final focusNode = FocusNode();

  WidgetInputField({
    Key? key,
    required this.controller,
    this.onSubmit,
    this.sendIcon,
    this.sendImage,
    required this.isKeyboardVisible,
    required this.isEmojiVisible,
    this.scrollController,
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
          IconButton(
            onPressed: sendImage,
            icon: Icon(
              Icons.image,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: sendIcon,
            icon: Icon(
              Icons.emoji_emotions,
              color: Colors.green,
            ),
          ),
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

  void onClickedEmoji() async {
    if (isEmojiVisible) {
      focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
}
