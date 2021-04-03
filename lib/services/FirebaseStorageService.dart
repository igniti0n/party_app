import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage instance = FirebaseStorage.instance;

  Future<String> storeUserImage(File image, String uid) async {
    try {
      return _storeFile(file: image, path: 'userImages/$uid/avatar.png');
    } catch (error) {
      throw error;
    }
  }

  Future<String> storePartyImage(File image, String partyId) async {
    try {
      return _storeFile(file: image, path: 'partyImages/$partyId.png');
    } catch (error) {
      throw error;
    }
  }

  Future<String> _storeFile({
    File file,
    String path,
    SettableMetadata storageMetadata,
  }) async {
    final Reference reference = instance.ref().child(path);
    final uploadTask = reference.putFile(file, storageMetadata);
    final snapshot = uploadTask.snapshot;
    if (snapshot.state == TaskState.error) {
      throw "Error occured while storing file.";
    } else {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
  }
}
