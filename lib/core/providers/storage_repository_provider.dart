import 'dart:io';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 25,
    );

    return File(result!.path);
  }

  Future<String> storeToFirebaseStorage(
    BuildContext context,
    String ref,
    File image,
  ) async {
    image = await compressFile(image);

    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    showSnackBar(context: context, text: "Image Seleceted");
    return downloadUrl;
  }
}
