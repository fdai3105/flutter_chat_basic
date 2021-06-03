import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdteam_demo_chat/app/data/constant/constant.dart';

class NotificationProvider {
  static NotificationProvider get instance => NotificationProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final dio = Dio();

  Future getDeviceToken() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        setDeviceToken();
        print('User granted permission');
      }
      if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        setDeviceToken();
        print('User granted provisional permission');
      }
      print('User declined or has not accepted permission');

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //de lam sau
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> setDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken(vapidKey: FB_VAPID_KEY).then((value) async {
      print('Token: ' + value!);
      prefs.setString('device_token', value);
    });
  }

  Future<void> pushNotifyToPeer(String name, String message, String senderUid, List<dynamic> regIds) async {
    try {
      await dio.postUri(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        options: Options(
          headers: {
            'Authorization': 'key=$FB_TOKEN',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(
          {
            'notification': {
              'title': name,
              'body': message,
            },
            'data': {
              'senderUid': senderUid,
              // 'type': type,
            },
            'registration_ids': regIds
          }
        )
      );
    } catch(e) {
      print(e);
    }
  }
}
