import 'dart:io';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(
    firebaseStorage: ref.read(firebaseStorageProvider),
  );
});

class StorageRepository {
  final FirebaseStorage firebaseStorage;
  StorageRepository({
    required this.firebaseStorage,
  });

  Future<String> storeToFirebaseStorage(
    BuildContext context,
    String ref,
    File image,
  ) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    showSnackBar(context: context, text: "Image Seleceted");
    return downloadUrl;
  }
}
