import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';

class ChatController extends GetxController {
  final ChatProvider provider;
  final StorageProvider storageProvider;

  ChatController({
    required this.provider,
    required this.storageProvider,
  });

  final textController = TextEditingController();

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
    provider.getMessages(Get.arguments['uID'])
      ..listen((event) {
        messages = event;
      });
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      this.isKeyboardVisible = isKeyboardVisible;
      if (isKeyboardVisible && emojiShowing) {
        emojiShowing = false;
      }
    });
    isLoading = false;
    super.onInit();
  }

  /// type 0: text; type 1: image
  void sendMessage(int type, String? url) {
    if (type == 0) {
      if (textController.text.isNotEmpty) {
        provider.sendMessage(Message(
            message: textController.text,
            senderUID: FirebaseAuth.instance.currentUser!.uid,
            receiverUID: Get.arguments['uID'],
            createdAt: DateTime.now().millisecondsSinceEpoch,
            type: type));
        textController.clear();
      }
    } else if (type == 1) {
      if (url == null) return;
      provider.sendMessage(Message(
          message: url,
          senderUID: FirebaseAuth.instance.currentUser!.uid,
          receiverUID: Get.arguments['uID'],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          type: type));
    }
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
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
        provider.sendMessage(Message(
            message: url,
            senderUID: FirebaseAuth.instance.currentUser!.uid,
            receiverUID: Get.arguments['uID'],
            createdAt: DateTime.now().millisecondsSinceEpoch,
            type: 1));
      });
    }
  }
}
