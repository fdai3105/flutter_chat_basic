import 'package:firebase_auth/firebase_auth.dart' as FB;

class User {
  String uID;
  String name;
  String email;
  String? avatar;

  User({
    required this.uID,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory User.fromAuth(FB.User userAuth) {
    return User(
      uID: userAuth.uid,
      name: userAuth.displayName ?? '',
      email: userAuth.email ?? '',
      avatar: userAuth.photoURL,
    );
  }

  factory User.fromMap(Map map) {
    return User(
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
