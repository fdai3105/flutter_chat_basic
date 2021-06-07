import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pdteam_demo_chat/app/data/constant/constant.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';

class UserProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future saveUserToStore(User user) async {
    final ref = store.collection('user').doc(user.uid);
    final isExit = await store.collection('user').doc(user.uid).get();
    final token = await firebaseMessaging.getToken(vapidKey: FB_VAPID_KEY);
    final tokens = await getListDeviceToken(user.uid);
    if (!isExit.exists) {
      await ref.set(MyUser.fromAuth(user, token!).toMap());
    } else {
      ref.update({'deviceToken': tokens..add(token!)});
    }
  }

  Future changeActive(bool isActive) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final ref = store.collection('user').doc(currentUser.uid);
      ref.update({'active': isActive});
    }
  }

  Future<List<MyUser>> getUsers() async {
    final users = <MyUser>[];
    final ref = await store
        .collection('user')
        .orderBy('active', descending: true)
        .orderBy('name')
        .get();
    ref.docs.forEach((element) {
      if (element.id != UserProvider.getCurrentUser().uid) {
        users.add(MyUser.fromMap(element.id, element.data()));
      }
    });
    return users;
  }

  Stream<List<MyUser>> getListUsers() {
    final ref = store
        .collection('user')
        .orderBy('active', descending: true)
        .orderBy('name');
    return ref.snapshots().transform(StreamTransformer.fromHandlers(
      handleData: (snapshot, sink) {
        final users = <MyUser>[];
        snapshot.docs.forEach((element) {
          if (element.id != getCurrentUser().uid) {
            users.add(MyUser.fromMap(element.id, element.data()));
          }
        });
        sink.add(users);
      },
    ));
  }

  Future<MyUser> getUser(String uid) async {
    final snapshot = await store.collection('user').doc(uid).get();
    return MyUser.fromMap(snapshot.id, snapshot.data()!);
  }

  // todo: check duplicate token
  Future<List<String>> getListDeviceToken(String uid) async {
    final ref = store.collection('user');
    final data = await ref.doc(uid).get();
    final d = data.data();
    if (d == null) {
      return [];
    }
    if (d.containsKey('deviceToken')) {
      return List<String>.from(data.get('deviceToken'));
    } else {
      return [];
    }
  }

  static User getCurrentUser() => FirebaseAuth.instance.currentUser!;
}
