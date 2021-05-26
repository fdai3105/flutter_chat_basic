import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String uID;
  String name;
  String email;
  String? avatar;

  MyUser({
    required this.uID,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory MyUser.fromAuth(User userAuth) {
    return MyUser(
      uID: userAuth.uid,
      name: userAuth.displayName ?? '',
      email: userAuth.email ?? '',
      avatar: userAuth.photoURL,
    );
  }

  factory MyUser.fromMap(Map map) {
    return MyUser(
      uID: map['uid'],
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uID;
    map['name'] = name;
    map['email'] = email;
    map['avatar'] = avatar;
    return map;
  }
}
