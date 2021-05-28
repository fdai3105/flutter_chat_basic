
part of 'models.dart';

class MyUser {
  final String uID;
  final String name;
  final String email;
  final String? avatar;
  final bool isActive;

  MyUser({
    required this.uID,
    required this.name,
    required this.email,
    this.avatar,
    required this.isActive,
  });

  factory MyUser.fromAuth(User userAuth) {
    return MyUser(
      uID: userAuth.uid,
      name: userAuth.displayName ?? '',
      email: userAuth.email ?? '',
      avatar: userAuth.photoURL,
      isActive: true,
    );
  }

  factory MyUser.fromMap(Map map) {
    return MyUser(
      uID: map['uid'],
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
      isActive: map['active'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uID;
    map['name'] = name;
    map['email'] = email;
    map['avatar'] = avatar;
    map['active'] = isActive;
    return map;
  }
}
