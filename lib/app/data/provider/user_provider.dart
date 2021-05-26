import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Stream<List<MyUser>> getListUsers() {
    final ref = store.collection('user');
    return ref.snapshots().transform(StreamTransformer.fromHandlers(
      handleData: (snapshot, sink) {
        final users = <MyUser>[];
        snapshot.docs.forEach((element) {
          users.add(MyUser.fromMap(element.data()));
        });
        sink.add(users);
      },
    ));
  }
}
