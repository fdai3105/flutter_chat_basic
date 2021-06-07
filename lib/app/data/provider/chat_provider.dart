import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdteam_demo_chat/app/data/models/models.dart';
import 'package:pdteam_demo_chat/app/data/provider/provider.dart';

class ChatProvider {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String id) {
    final ref =
        store.collection('conversations').doc(id).collection('messages');
    return ref.orderBy('created_at', descending: true).snapshots().transform(
        StreamTransformer.fromHandlers(handleData: _tranDocToMessages));
  }

  void _tranDocToMessages(QuerySnapshot<Map<String, dynamic>> snapshot,
      EventSink<List<Message>> sink) {
    final messages = <Message>[];
    for (final element in snapshot.docs) {
      messages.add(Message.fromMap(element.data()));
    }
    sink.add(messages);
  }

  Stream<List<Message>> getMessagesFromContact(String contactUID) {
    var doc = '';
    if (contactUID.hashCode <= UserProvider.getCurrentUser()!.uid.hashCode) {
      doc = contactUID + UserProvider.getCurrentUser()!.uid;
    } else {
      doc = UserProvider.getCurrentUser()!.uid + contactUID;
    }
    final ref =
        store.collection('conversations').doc(doc).collection('messages');
    return ref
        .orderBy('created_at', descending: true)
        .snapshots()
        .transform(StreamTransformer.fromHandlers(
          handleData: _tranDocToMessagesFromContact,
        ));
  }

  void _tranDocToMessagesFromContact(
      QuerySnapshot<Map<String, dynamic>> snapshot,
      EventSink<List<Message>> sink) {
    final messages = <Message>[];
    for (final element in snapshot.docs) {
      messages.add(Message.fromMap(element.data()));
    }
    sink.add(messages);
  }

  Future sendMessage(String? uid, Message message) async {
    final ref = store.collection('conversations').doc(uid);
    final a = await ref.get();
    if (a.data() != null) {
      if (a.data()!.containsKey('last_message')) {
        ref.update({'last_message': message.toMap()});
      } else {
        final data = a.data()!..addAll({'last_message': message.toMap()});
        ref.set(data);
      }
    } else {
      ref.set({
        'last_message': message.toMap(),
        'members': [UserProvider.getCurrentUser()!.uid, message.senderUID],
      });
    }
    ref.collection('messages').add(message.toMap());
  }

  Future sendMessageFromContact(String senderToUID, Message message) async {
    var doc = '';
    if (senderToUID.hashCode <= UserProvider.getCurrentUser()!.uid.hashCode) {
      doc = senderToUID + UserProvider.getCurrentUser()!.uid;
    } else {
      doc = UserProvider.getCurrentUser()!.uid + senderToUID;
    }

    final ref = store.collection('conversations').doc(doc);
    final a = await ref.get();
    if (a.data() != null) {
      if (a.data()!.containsKey('last_message')) {
        ref.update({'last_message': message.toMap()});
      } else {
        final data = a.data()!..addAll({'last_message': message.toMap()});
        ref.set(data);
      }
    } else {
      ref.set({
        'last_message': message.toMap(),
        'members': [UserProvider.getCurrentUser()!.uid, senderToUID],
      });
    }
    ref.collection('messages').add(message.toMap());
  }
}
