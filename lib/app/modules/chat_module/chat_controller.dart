import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/chat_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  final ChatProvider provider;

  ChatController({required this.provider});

  final textController = TextEditingController();
  final _emojiShowing = false.obs;
  final _isKeyboardVisible = false.obs;
  String imageUrl = '';
  File? imageFile;

  get isKeyboardVisible => _isKeyboardVisible.value;

  set isKeyboardVisible(value) {
    _isKeyboardVisible.value = value;
  }

  final _isLoading = true.obs;
  final _messages = <Message>[].obs;

  get emojiShowing => _emojiShowing.value;

  set emojiShowing(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    _emojiShowing.value = value;
  }

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
        messages = event;
      });

    imageUrl = '';

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      this.isKeyboardVisible = isKeyboardVisible;
      if (isKeyboardVisible && emojiShowing) {
        emojiShowing = false;
      }
    });
    isLoading = false;
    super.onInit();
  }

  void sendMessage(int type, String? url) {
    //type 0: text; type 1: image
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
      if (url == null) {
        return;
      }
      provider.sendMessage(Message(
          message: url,
          senderUID: FirebaseAuth.instance.currentUser!.uid,
          receiverUID: Get.arguments['uID'],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          type: type));
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

  toggleEmojiKeyboard() {
    if (isKeyboardVisible) {
      FocusScope.of(Get.context!).unfocus();
    }
    emojiShowing = !emojiShowing;
  }

  Future<bool> onBackPress() {
    if (emojiShowing) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(Get.context!);
    }
    return Future.value(false);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);

    if (imageFile != null) {
      isLoading = true;
      uploadFile();
    } else {
      print('no image');
    }
  }

  Future uploadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile!);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        isLoading = false;
        sendMessage(1, imageUrl);
      }, onError: (err) {
        isLoading = false;
      });
    });
  }
}
