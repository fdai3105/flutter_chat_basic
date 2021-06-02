part of 'models.dart';

class Group {
  final String uid;
  final String name;
  final FirebaseMessage? lastMessage;
  final List<MyUser> members;

  const Group({
    required this.uid,
    required this.name,
    this.lastMessage,
    required this.members,
  });
}
