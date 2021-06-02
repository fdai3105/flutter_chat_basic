part of 'models.dart';
class Message {
  final String senderUID;
  final String receiverUID;
  final String? message;
  final int createdAt;
  final int type;

  Message({
    required this.senderUID,
    required this.receiverUID,
    this.message,
    required this.createdAt,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_uid': senderUID,
      'receiver_uid' : receiverUID,
      'message': message,
      'created_at': createdAt,
      'type': type
    };
  }

  factory Message.fromMap(Map map) {
    return Message(
      senderUID: map['sender_uid'],
      receiverUID: map['receiver_uid'],
      message: map['message'],
      createdAt: map['created_at'],
      type:  map['type']
    );
  }
}

