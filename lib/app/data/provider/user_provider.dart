import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdteam_demo_chat/app/data/models/user.dart' as MyUser;

class UserProvider {
  final FirebaseFirestore store;

  UserProvider({required this.store});

  Future saveUserToStore(User user) async {
    final ref = store.collection('user').doc(user.uid);
    final isExit = await ref.get();
    if (!isExit.exists) {
      await ref.set(MyUser.User.fromAuth(user).toMap());
    }
  }

  Future<List<MyUser.User>> getListUsers() async {
    final users = <MyUser.User>[];
    final ref = await store.collection('user').get();
    ref.docs.forEach((element) {
      users.add(MyUser.User.fromMap(element.data()));
    });
    return users;
  }
}
