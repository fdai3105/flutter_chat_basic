part of 'models.dart';

class FirebaseMessage {
  final String senderUID;
  final String senderName;
  final String message;
  final int createdAt;

  FirebaseMessage({
    required this.senderUID,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_uid': senderUID,
      'sender_name' : senderName,
      'message': message,
      'created_at': createdAt,
    };
  }

  factory FirebaseMessage.fromMap(Map map) {
    return FirebaseMessage(
      senderUID: map['sender_uid'],
      senderName: map['sender_name'],
      message: map['message'],
      createdAt: map['created_at'],
    );
  }
}
