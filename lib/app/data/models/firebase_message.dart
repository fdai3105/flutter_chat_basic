part of 'models.dart';

class FirebaseMessage {
  final String senderUID;
  final String message;
  final int createdAt;

  FirebaseMessage({
    required this.senderUID,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_uid': senderUID,
      'message': message,
      'created_at': createdAt,
    };
  }

  factory FirebaseMessage.fromMap(Map map) {
    return FirebaseMessage(
      senderUID: map['sender_uid'],
      message: map['message'],
      createdAt: map['created_at'],
    );
  }
}
