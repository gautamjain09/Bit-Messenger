import 'dart:io';
import 'package:bit_messenger/core/constants.dart';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/providers/storage_repository_provider.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/features/auth/screens/user_info_screen.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:bit_messenger/features/home/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------- Providers ---------------------------------------------->

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);

//------------------------ Repository & Methods ------------------------------------>

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<void> signUpwithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      UserModel userModel = UserModel(
        name: "My Name",
        uid: uid,
        profileUrl: Constants.defaultProfileImage,
        isOnline: true,
        email: email,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(userModel.toMap());

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const UserInfoScreen();
        }),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      showSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  Future<void> loginInwithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  void saveUserDataToFirestore(
    BuildContext context,
    String name,
    File? profileImage,
    ProviderRef ref,
  ) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      String profileUrl = Constants.defaultProfileImage;

      // Stroing Profile Image To Storage
      if (profileImage != null) {
        profileUrl = await ref
            .watch(storageRepositoryProvider)
            .storeImageToFirebaseStorage(
                context, 'profilePic/$uid', profileImage);
      }

      UserModel userModel = UserModel(
        name: name,
        uid: uid,
        profileUrl: profileUrl,
        isOnline: true,
        email: firebaseAuth.currentUser!.email!,
        groupId: [],
      );

      // Storing to Database
      await firestore.collection('users').doc(uid).set(userModel.toMap());

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.message!,
      );
    }
  }

  // For State Persistance
  Future<UserModel?> getCurrentUserData(String uid) async {
    DocumentSnapshot userData;
    userData = await firestore.collection("users").doc(uid).get();

    UserModel? userModel;
    if (userData.data() != null) {
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  // For getting userModel by uid
  Stream<UserModel> getUserData(String uid) {
    return firestore.collection("users").doc(uid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  void logOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> setUserState(bool isOnline) async {
    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .update({"isOnline": isOnline});
  }
}
