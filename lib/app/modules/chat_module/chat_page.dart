import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';
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
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: GetX<ChatController>(
                builder: (_) {
                  if (controller.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    controller: controller.scrollController,
                    reverse: true,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, i) {
                      final item = controller.messages[i];
                      return WidgetBubble(
                        dateTime:
                            '${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.createdAt))}',
                        message: item.message,
                        isMe:
                            item.senderUID == UserProvider.getCurrentUser().uid,
                        type: item.type,
                        avatar: item.senderAvatar,
                      );
                    },
                  );
                },
              ),
            ),
            GetX<ChatController>(
              builder: (_) {
                return Visibility(
                  visible: controller.tagging,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.members.length,
                      itemBuilder: (context, i) {
                        final item = controller.members[i];
                        return ListTile(
                          onTap: () => controller.onTagSelect(item),
                          leading: WidgetAvatar(
                            url: item.avatar,
                            size: 40,
                          ),
                          title: Text(item.name),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            WidgetInputField(
              controller: controller.textController,
              onSubmit: () => controller.sendMessage(),
              sendIcon: () {
                controller.emojiShowing = !controller.emojiShowing;
              },
              sendSticker: () {
                controller.stickerShowing = !controller.stickerShowing;
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
            GetX<ChatController>(
              builder: (_){
                return  Visibility(
                    visible: controller.stickerShowing,
                    child: WidgetSticker()
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black87),
      title: Row(
        children: [
          Hero(
            tag: controller.id,
            child: WidgetAvatarChat(
              members: Get.arguments['members'],
              isGroup: Get.arguments['uID'].length <= 20,
              size: 40,
              avatarSize: 28,
            ),
          ),
          SizedBox(width: 12),
          Text(
            Get.arguments['name'],
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class WidgetInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? onSubmit;
  final Function()? sendIcon;
  final Function()? sendImage;
  final Function()? sendSticker;
  final bool isKeyboardVisible;
  final bool isEmojiVisible;

  WidgetInputField({
    Key? key,
    required this.controller,
    this.onSubmit,
    this.sendIcon,
    this.sendImage,
    this.sendSticker,
    required this.isKeyboardVisible,
    required this.isEmojiVisible,
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
            onPressed: sendSticker,
            icon: Icon(
              Icons.face,
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
}


