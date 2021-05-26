import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdteam_demo_chat/app/data/models/message.dart';

class ChatProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  // Future<Stream<List<Message>>> getMessages(String uID) async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   final ref = await store
  //       .collection('conversations')
  //       .where('members', arrayContains: currentUser!.uid)
  //       .get();
  //
  //   if (ref.size < 1) {
  //     return Stream.empty();
  //   }
  //
  //   return store
  //       .collection('conversations')
  //       .doc(ref.docs.first.id)
  //       .collection('messages')
  //       .snapshots()
  //       .transform(StreamTransformer.fromHandlers(
  //     handleData: (snapshot, sink) {
  //       final messages = <Message>[];
  //       snapshot.docs.forEach((element) {
  //         messages.add(Message.fromMap(element.data()));
  //       });
  //       sink.add(messages);
  //     },
  //   ));
  // }
  //
  // Future sendMessage(Message message) async {
  //   final ref = await store.collection('conversations').where('members',
  //       arrayContainsAny: [message.senderUID, message.receiverUID]).get();
  //
  //   if (ref.docs.isEmpty) {
  //     final newC = await store.collection('conversations').add({
  //       'members': [message.senderUID, message.receiverUID]
  //     });
  //
  //     store
  //         .collection('conversations')
  //         .doc(newC.id)
  //         .collection('messages')
  //         .add(message.toMap());
  //   } else {
  //     store
  //         .collection('conversations')
  //         .doc(ref.docs.first.id)
  //         .collection('messages')
  //         .add(message.toMap());
  //   }
  // }
}
