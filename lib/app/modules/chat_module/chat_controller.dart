import 'dart:io';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
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
  final _showMore = false.obs;
  final _isKeyboardVisible = false.obs;
  final _messages = <Message>[].obs;
  final _isLoading = true.obs;

  get showMore => _showMore.value;

  set showMore(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    _showMore.value = value;
  }

  /*------------------------*/
  final _tagging = false.obs;
  final _members = <MyUser>[].obs;
  final _listTagged = <MyUser>[].obs;

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
    } else if (value && stickerShowing) {
      stickerShowing = false;
    }
    _emojiShowing.value = value;
  }

  get stickerShowing => _stickerShowing.value;

  set stickerShowing(value) {
    if (value && Get.window.viewInsets.bottom != 0) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    } else if (value && emojiShowing) {
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

  get tagging => _tagging.value;

  set tagging(value) {
    _tagging.value = value;
  }

  List<MyUser> get members => _members;

  List<MyUser> get membersWithoutMe => _members
      .where((element) => element.uid != UserProvider.getCurrentUser().uid)
      .toList();

  set members(value) {
    _members.value = value;
  }

  List<MyUser> get listTagged => _listTagged;

  set listTagged(value) {
    _listTagged.value = value;
  }

  @override
  void onInit() async {
    id = Get.arguments['uID'];
    name = Get.arguments['name'];
    fromContact = Get.arguments['isFromContact'];
    deviceToken = Get.arguments['deviceToken'];
    members = List<MyUser>.from(Get.arguments['members']);
    /*-----------------------------------------------*/
    textController.addListener(() {
      textController.text.split(' ').forEach((e) {
        if (e.startsWith('@')) {
          tagging = true;
        } else {
          tagging = false;
        }
      });
    });
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
      } else if (isKeyboardVisible && showMore) {
        showMore = false;
      }
    });
    super.onInit();
  }

  void onTagSelect(MyUser user) {
    tagging = !tagging;
    textController.text += user.name;
    listTagged.add(user);
    _moveCursorToLast();
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      // TODO(ff3105): need to optimize
      if (listTagged.isNotEmpty) {
        for (var value in listTagged) {
          ntfProvider.pushNotifyToPeer(
              name,
              UserProvider.getCurrentUser().displayName! + ' has mention you',
              UserProvider.getCurrentUser().uid,
              value.deviceToken ?? []);
        }
      }

      final message = Message(
        senderUID: UserProvider.getCurrentUser().uid,
        senderName: UserProvider.getCurrentUser().displayName!,
        senderAvatar: UserProvider.getCurrentUser().photoURL,
        message: textController.text,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: 0,
      );
      if (fromContact) {
        provider.sendMessageFromContact(id, message);
        ntfProvider.pushNotifyToPeer(
            UserProvider.getCurrentUser().displayName!,
            textController.text,
            UserProvider.getCurrentUser().uid,
            deviceToken ?? []);
      } else {
        provider.sendMessage(id, message);
        ntfProvider.pushNotifyToPeer(
            name,
            UserProvider.getCurrentUser().displayName! +
                ': ${textController.text}',
            UserProvider.getCurrentUser().uid,
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
        type: 2);
    if (fromContact) {
      provider.sendMessageFromContact(id, message);
      ntfProvider.pushNotifyToPeer(
          UserProvider.getCurrentUser().displayName!,
          UserProvider.getCurrentUser().displayName! + ' send a sticker',
          UserProvider.getCurrentUser().uid,
          deviceToken ?? []);
    } else {
      provider.sendMessage(id, message);
      ntfProvider.pushNotifyToPeer(
          name,
          UserProvider.getCurrentUser().displayName! + ' send a sticker ',
          UserProvider.getCurrentUser().uid,
          deviceToken ?? []);
    }
  }

  void onEmojiSelected(Emoji emoji) {
    textController.text += emoji.emoji;
    _moveCursorToLast();
  }

  void onBackspacePressed() {
    textController.text = textController.text.characters.skipLast(1).string;
    _moveCursorToLast();
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
    pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 30);
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
              UserProvider.getCurrentUser().displayName!,
              UserProvider.getCurrentUser().displayName! + ' send a photo',
              UserProvider.getCurrentUser().uid,
              deviceToken ?? []);
        } else {
          provider.sendMessage(id, message);
          ntfProvider.pushNotifyToPeer(
              name,
              UserProvider.getCurrentUser().displayName! + ' send a photo ',
              UserProvider.getCurrentUser().uid,
              deviceToken ?? []);
        }
      });
    }
  }

  void _moveCursorToLast() {
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
  }

  void sendLocation() async {
    if (fromContact) {
      await getLocation().then((position) {
        provider.sendMessageFromContact(
            id,
            Message(
              senderUID: UserProvider.getCurrentUser().uid,
              senderName: UserProvider.getCurrentUser().displayName!,
              message: '${position.latitude} ${position.longitude}',
              senderAvatar: UserProvider.getCurrentUser().photoURL!,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              type: 3,
            ));
        ntfProvider.pushNotifyToPeer(
            UserProvider.getCurrentUser().displayName!,
            UserProvider.getCurrentUser().displayName! + ' send a location',
            UserProvider.getCurrentUser().uid,
            deviceToken ?? []);
      });
    } else {
      await getLocation().then((position) => {
            provider.sendMessage(
                id,
                Message(
                  senderUID: UserProvider.getCurrentUser().uid,
                  senderName: UserProvider.getCurrentUser().displayName!,
                  message: '${position.latitude} ${position.longitude}',
                  senderAvatar: UserProvider.getCurrentUser().photoURL!,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  type: 3,
                )),
            ntfProvider.pushNotifyToPeer(
                name,
                UserProvider.getCurrentUser().displayName! +
                    ' send a location ',
                UserProvider.getCurrentUser().uid,
                deviceToken ?? [])
          });
    }
  }

  Future<Position> getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
