import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  if (result != null) {
    image = File(result.files.single.path!);
  }
  return image;
}

Future<File?> pickVideo(BuildContext context) async {
  File? video;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.video,
  );

  if (result != null) {
    video = File(result.files.single.path!);
  }
  return video;
}
