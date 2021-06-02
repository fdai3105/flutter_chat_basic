part of 'models.dart';

class MyUser {
  final String uid;
  final String name;
  final String email;
  final String? avatar;
  final bool isActive;
  final List<dynamic>? deviceToken;

  MyUser({
    required this.uid,
    required this.name,
    required this.email,
    this.avatar,
    required this.isActive,
    this.deviceToken,
  });

  factory MyUser.fromAuth(User userAuth, String deviceToken) {
    return MyUser(
      uid: userAuth.uid,
      name: userAuth.displayName ?? '',
      email: userAuth.email ?? '',
      avatar: userAuth.photoURL,
      isActive: true,
      deviceToken: [deviceToken],
    );
  }

  factory MyUser.fromMap(String uid, Map map) {
    return MyUser(
      uid: uid,
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
      isActive: map['active'],
      deviceToken: map['deviceToken'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['email'] = email;
    map['avatar'] = avatar;
    map['active'] = isActive;
    map['deviceToken'] = deviceToken;
    return map;
  }
}
