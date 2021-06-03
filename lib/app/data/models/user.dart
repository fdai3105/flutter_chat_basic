
part of 'models.dart';

class MyUser {
  final String uid;
  final String name;
  final String email;
  final String? avatar;
  final bool isActive;

  MyUser({
    required this.uid,
    required this.name,
    required this.email,
    this.avatar,
    required this.isActive,
  });

  factory MyUser.fromAuth(User userAuth) {
    return MyUser(
      uid: userAuth.uid,
      name: userAuth.displayName ?? '',
      email: userAuth.email ?? '',
      avatar: userAuth.photoURL,
      isActive: true,
    );
  }

  factory MyUser.fromMap(String uid,Map map) {
    return MyUser(
      uid: uid,
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
      isActive: map['active'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['email'] = email;
    map['avatar'] = avatar;
    map['active'] = isActive;
    return map;
  }
}
