import 'dart:io';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

class ChatController extends GetxController {
  final ChatProvider provider;
  final StorageProvider storageProvider;
  final NotificationProvider ntfProvider;

  ChatController({
    required this.provider,
    required this.storageProvider,
    required this.ntfProvider,
  });

  final textController = TextEditingController();
  final keyboardController = KeyboardVisibilityController();
  final scrollController = ScrollController();

  final _emojiShowing = false.obs;
  final _isKeyboardVisible = false.obs;
  final _messages = <Message>[].obs;
  final _isLoading = true.obs;

  get emojiShowing => _emojiShowing.value;

  set emojiShowing(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    _emojiShowing.value = value;
  }

  get isKeyboardVisible => _isKeyboardVisible.value;

  set isKeyboardVisible(value) {
    _isKeyboardVisible.value = value;
  }

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
    if (Get.arguments['isFromContact']) {
      provider.getMessagesFromContact(Get.arguments['uID'])
        ..listen((event) {
          messages = event;
        });
    } else {
      provider.getMessages(Get.arguments['uID'])
        ..listen((event) {
          messages = event;
        });
    }
    isLoading = false;
    print('${Get.arguments['name']} TOKEN: ${Get.arguments['deviceToken']}');
    super.onInit();
  }

  /// type 0: text; type 1: image
  void sendMessage() {
    if (Get.arguments['isFromContact']) {
      if (textController.text.isNotEmpty) {
        provider.sendMessageFromContact(
            Get.arguments['uID'],
            FirebaseMessage(
              senderUID: UserProvider.getCurrentUser()!.uid,
              senderName: UserProvider.getCurrentUser()!.displayName!,
              message: textController.text,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              type: 0,
            ));
        ntfProvider
            .pushNotifyToPeer(
            Get.arguments['name'],
            textController.text,
            UserProvider.getCurrentUser()!.uid,
            Get.arguments['deviceToken'] ?? []);
        textController.clear();
      }
    } else {
      if (textController.text.isNotEmpty) {
        provider.sendMessage(
            Get.arguments['uID'],
            FirebaseMessage(
              senderUID: UserProvider.getCurrentUser()!.uid,
              senderName: UserProvider.getCurrentUser()!.displayName!,
              message: textController.text,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              type: 0,
            ));
        ntfProvider
            .pushNotifyToPeer(
            Get.arguments['name'],
            textController.text,
            UserProvider.getCurrentUser()!.uid,
            Get.arguments['deviceToken'] ?? []);
        textController.clear();
      }
    }

    if (messages.length >= 1) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void onEmojiSelected(Emoji emoji) {
    textController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }

  void onBackspacePressed() {
    textController
      ..text = textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }

  void toggleEmojiKeyboard() {
    if (isKeyboardVisible) {
      FocusScope.of(Get.context!).unfocus();
    }
  }

  Future<bool> onBackPress() {
    if (emojiShowing) {
      toggleEmojiKeyboard();
      emojiShowing = !emojiShowing;
    } else {
      Navigator.pop(Get.context!);
    }
    return Future.value(false);
  }

  Future sendImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final ref = await storageProvider.uploadFile(imageFile);
      ref.getDownloadURL().then((url) {
        provider.sendMessage(
            Get.arguments['uID'],
            FirebaseMessage(
                senderUID: UserProvider.getCurrentUser()!.uid,
                senderName: UserProvider.getCurrentUser()!.displayName!,
                message: url,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                type: 1));
      });
    }
  }
}
