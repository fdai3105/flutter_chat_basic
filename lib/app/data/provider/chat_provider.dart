import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdteam_demo_chat/app/data/models/message.dart';

class ChatProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String uID) {
    final currentUser = FirebaseAuth.instance.currentUser;

    var docID = '';
    if (currentUser!.uid.hashCode <= uID.hashCode) {
      docID = uID + currentUser.uid;
    } else {
      docID = currentUser.uid + uID;
    }

    final ref =
        store.collection('conversations').doc(docID).collection('messages');

    return ref
        .orderBy('created_at', descending: true)
        .snapshots()
        .transform(StreamTransformer.fromHandlers(
      handleData: (snapshot, sink) {
        final messages = <Message>[];
        snapshot.docs.forEach((element) {
          messages.add(Message.fromMap(element.data()));
        });
        sink.add(messages);
      },
    ));
  }

  Future sendMessage(Message message) async {
    final ref = store.collection('conversations');

    var docID = '';
    if (message.senderUID.hashCode <= message.receiverUID.hashCode) {
      docID = message.receiverUID + message.senderUID;
    } else {
      docID = message.senderUID + message.receiverUID;
    }

    ref
        .doc(docID)
        .collection('messages')
        .add(message.toMap());
  }
}
