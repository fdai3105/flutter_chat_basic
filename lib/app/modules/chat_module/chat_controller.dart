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

  final _id = ''.obs;
  final _name = ''.obs;
  final _deviceToken = <dynamic>[].obs;
  final _fromContact = false.obs;
  final _emojiShowing = false.obs;
  final _stickerShowing = false.obs;
  final _isKeyboardVisible = false.obs;
  final _messages = <Message>[].obs;
  final _isLoading = true.obs;

  get id => _id.value;

  set id(value) {
    _id.value = value;
  }

  get name => _name.value;

  set name(value) {
    _name.value = value;
  }

  get deviceToken => _deviceToken;

  set deviceToken(value) {
    _deviceToken.value = value;
  }

  get fromContact => _fromContact.value;

  set fromContact(value) {
    _fromContact.value = value;
  }

  get emojiShowing => _emojiShowing.value;

  set emojiShowing(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    } else if (value && stickerShowing){
      stickerShowing = false;
    }
    _emojiShowing.value = value;
  }

  get stickerShowing => _stickerShowing.value;

  set stickerShowing(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    } else if (value && emojiShowing){
      emojiShowing = false;
    }
    _stickerShowing.value = value;
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
    id = Get.arguments['uID'];
    name = Get.arguments['name'];
    fromContact = Get.arguments['isFromContact'];
    deviceToken = Get.arguments['deviceToken'];

    if (fromContact) {
      provider.getMessagesFromContact(id)
        ..listen((event) {}).onData((data) {
          messages = data;
          isLoading = false;
        });
    } else {
      provider.getMessages(id)
        ..listen((event) {}).onData((data) {
          messages = data;
          isLoading = false;
        });
    }

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      this.isKeyboardVisible = isKeyboardVisible;
      if (isKeyboardVisible && emojiShowing) {
        emojiShowing = false;
      } else if (isKeyboardVisible && stickerShowing) {
        stickerShowing = false;
      }
    });
    super.onInit();
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      final message = Message(
        senderUID: UserProvider
            .getCurrentUser()
            .uid,
        senderName: UserProvider
            .getCurrentUser()
            .displayName!,
        senderAvatar: UserProvider
            .getCurrentUser()
            .photoURL,
        message: textController.text,
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
        type: 0,
      );
      if (fromContact) {
        provider.sendMessageFromContact(id, message);
        ntfProvider.pushNotifyToPeer(
            UserProvider
                .getCurrentUser()
                .displayName!,
            textController.text,
            UserProvider
                .getCurrentUser()
                .uid,
            deviceToken ?? []);
      } else {
        provider.sendMessage(id, message);
        ntfProvider.pushNotifyToPeer(
            name,
            UserProvider
                .getCurrentUser()
                .displayName! +
                ': ${textController.text}',
            UserProvider
                .getCurrentUser()
                .uid,
            deviceToken ?? []);
      }
      textController.clear();
      if (messages.length >= 1) {
        scrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  void sendSticker(String? url) {
    final message = Message(
        senderUID: UserProvider.getCurrentUser().uid,
        senderName: UserProvider.getCurrentUser().displayName!,
        senderAvatar: UserProvider.getCurrentUser().photoURL,
        message: url!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: 2
    );
    if (fromContact) {
      provider.sendMessageFromContact(id, message);
    } else {
      provider.sendMessage(id, message);
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
    } else if (stickerShowing) {
      toggleEmojiKeyboard();
      stickerShowing = !stickerShowing;
    } else {
      Navigator.pop(Get.context!);
    }
    return Future.value(false);
  }

  Future sendImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile =
    await imagePicker.getImage(source: ImageSource.gallery, imageQuality: 30);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final ref = await storageProvider.uploadFile(imageFile);
      ref.getDownloadURL().then((url) {
        final message = Message(
            senderUID: UserProvider.getCurrentUser().uid,
            senderName: UserProvider.getCurrentUser().displayName!,
            senderAvatar: UserProvider.getCurrentUser().photoURL,
            message: url,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            type: 1);
        if (fromContact) {
          provider.sendMessageFromContact(id, message);
          ntfProvider.pushNotifyToPeer(
              UserProvider
                  .getCurrentUser()
                  .displayName!,
              UserProvider
                  .getCurrentUser()
                  .displayName! + ' send a photo',
              UserProvider
                  .getCurrentUser()
                  .uid,
              deviceToken ?? []);
        } else {
          provider.sendMessage(id, message);
          ntfProvider.pushNotifyToPeer(
              name,
              UserProvider
                  .getCurrentUser()
                  .displayName! + ' send a photo ',
              UserProvider
                  .getCurrentUser()
                  .uid,
              deviceToken ?? []);
        }
      });
    }
  }
}