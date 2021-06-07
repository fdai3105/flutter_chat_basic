part of 'models.dart';

class Message {
  final String? id;
  final String senderUID;
  final String senderName;
  final String? senderAvatar;
  final String message;
  final int type;
  final int createdAt;

  Message({
    this.id,
    required this.senderUID,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_uid': senderUID,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'message': message,
      'type': type,
      'created_at': createdAt,
    };
  }

  factory Message.fromMap(Map map) {
    return Message(
      id: map['id'],
      senderUID: map['sender_uid'],
      senderName: map['sender_name'],
      senderAvatar: map['sender_avatar'],
      message: map['message'],
      type: map['type'],
      createdAt: map['created_at'],
    );
  }
}
