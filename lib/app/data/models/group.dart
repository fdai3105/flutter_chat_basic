part of 'models.dart';

class Group {
  final String uid;
  final Message? lastMessage;
  final List<MyUser> members;

  Group({required this.uid, this.lastMessage, required this.members});

  @override
  String toString() {
    return 'Group{uid: $uid, lastMessage: $lastMessage, members: $members}';
  }
}
