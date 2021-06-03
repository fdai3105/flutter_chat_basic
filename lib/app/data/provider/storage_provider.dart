import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<Reference> uploadFile(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child(fileName);
    final uploadTask = await ref.putFile(file);
    return uploadTask.ref;
  }
}
