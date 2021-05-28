part of 'models.dart';
class Message {
  final String senderUID;
  final String receiverUID;
  final String message;
  final String createdAt;

  Message({
    required this.senderUID,
    required this.receiverUID,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_uid': senderUID,
      'receiver_uid': receiverUID,
      'message': message,
      'created_at': createdAt,
    };
  }

  factory Message.fromMap(Map map) {
    return Message(
      senderUID: map['sender_uid'],
      receiverUID: map['receiver_uid'],
      message: map['message'],
      createdAt: map['created_at'],
    );
  }

  @override
  String toString() {
    return 'senderUID: $senderUID, receiverUID: $receiverUID, message: $message, createdAt: $createdAt';
  }
}
