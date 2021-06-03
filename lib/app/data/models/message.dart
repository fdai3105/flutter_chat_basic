part of 'models.dart';

class Message {
  final String uid;
  final String senderUID;
  final MyUser sender;
  final String message;
  final int createdAt;

  Message({
    required this.uid,
    required this.senderUID,
    required this.sender,
    required this.message,
    required this.createdAt,
  });
}
