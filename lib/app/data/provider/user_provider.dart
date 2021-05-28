import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdteam_demo_chat/app/data/models/message.dart';
import 'package:pdteam_demo_chat/app/data/models/user.dart';

class UserProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Future saveUserToStore(User user) async {
    final ref = store.collection('user').doc(user.uid);
    final isExit = await ref.get();
    if (!isExit.exists) {
      await ref.set(MyUser.fromAuth(user).toMap());
    }
  }

  Future changeActive(bool isActive) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final ref = store.collection('user').doc(currentUser.uid);
      ref.update({'active': isActive});
    }
  }

  Future<Stream<List<MyUser>>> getListUsers() async {
    final ref = store
        .collection('user')
        .orderBy('active', descending: true)
        .orderBy('name');
    return ref.snapshots().transform(StreamTransformer.fromHandlers(
      handleData: (snapshot, sink) {
        final users = <MyUser>[];
        snapshot.docs.forEach((element) async {
          if (element.id != getCurrentUser()!.uid)  {
            users.add(
              MyUser.fromMap(element.data())
            );
        }
        });
        sink.add(users);
      },
    ));
  }
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;
}
