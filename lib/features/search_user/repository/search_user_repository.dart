import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchUserRepositoryProvider = Provider((ref) {
  return SearchUserRepository(
    firestore: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

class SearchUserRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  SearchUserRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  Stream<List<UserModel?>> searchUserByEmail({required String query}) {
    return firestore
        .collection("users")
        .where('email',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? 0
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<UserModel?> users = [];
      for (var document in event.docs) {
        users.add(UserModel.fromMap(document.data()));
      }
      return users;
    });
  }
}
