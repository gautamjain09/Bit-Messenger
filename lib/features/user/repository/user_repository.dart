import 'dart:io';

import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/providers/storage_repository_provider.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/home/screens/home_screen.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(
    firestore: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

class UserRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  UserRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  Stream<List<UserModel>> searchUserByEmail({required String query}) {
    return firestore
        .collection('users')
        .where('email',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? 0
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var document in event.docs) {
        users.add(UserModel.fromMap(document.data()));
      }
      return users;
    });
  }

  Stream<List<UserModel>> getAllUsers() {
    return firestore.collection('users').snapshots().map((event) {
      List<UserModel> users = [];
      for (var document in event.docs) {
        users.add(UserModel.fromMap(document.data()));
      }
      return users;
    });
  }

  Future<void> updateUserProfile(
    BuildContext context,
    File? profileImage,
    String profileUrl,
    ProviderRef ref,
  ) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;

      // Stroing Profile Image To Storage
      if (profileImage != null) {
        profileUrl = await ref
            .watch(storageRepositoryProvider)
            .storeImageToFirebaseStorage(
                context, 'profilePic/$uid', profileImage);
      }

      // Storing to Database
      await firestore
          .collection('users')
          .doc(uid)
          .update({'profileUrl': profileUrl});
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.message!,
      );
    }
  }
}
