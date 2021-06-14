import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              textEditingController: controller.textController,
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
              sendLocation: () {
                _showModalBottom(context);
                controller.getLocation();
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
              builder: (_) {
                return Visibility(
                    visible: controller.stickerShowing, child: WidgetSticker());
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

  _showModalBottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(8),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(45.521563, -122.677433),
                  zoom: 11
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              controller.sendLocation();
              Get.back();
            },
            child: Icon(Icons.send),
          ),
        ));
  }
}

class WidgetInputField extends GetView<ChatController> {
  final TextEditingController textEditingController;
  final Function()? onSubmit;
  final Function()? sendIcon;
  final Function()? sendImage;
  final Function()? sendSticker;
  final Function()? sendLocation;
  final bool isKeyboardVisible;
  final bool isEmojiVisible;

  WidgetInputField({
    Key? key,
    required this.textEditingController,
    this.onSubmit,
    this.sendIcon,
    this.sendImage,
    this.sendSticker,
    this.sendLocation,
    required this.isKeyboardVisible,
    required this.isEmojiVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetX<ChatController>(
          builder: (_){
            return Visibility(
                visible: controller.showMore,
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
                    IconButton(
                      onPressed: sendLocation,
                      icon: Icon(
                        Icons.add_location,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
            );
          },
        ),
        GetX<ChatController>(
          builder: (_){
            return IconButton(
                icon: Icon(
                  controller.showMore
                      ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  color: Colors.green,
                ),
                onPressed: (){
                  controller.showMore = !controller.showMore;
                }
            );
          },
        ),
        Expanded(
          child: Container(
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
                    controller: textEditingController,
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}


