import 'dart:io';
import 'package:bit_messenger/core/constants.dart';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/providers/storage_repository_provider.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/features/auth/screens/otp_screen.dart';
import 'package:bit_messenger/features/auth/screens/user_info_screen.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:bit_messenger/home_screen.dart';
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

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OTPScreen(id: verificationId)),
          );
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message!);
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.message!,
      );
    }
  }

  void veriflyOTP(
    BuildContext context,
    String verificationId,
    String userOTP,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await firebaseAuth.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.message!,
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
            .storeToFirebaseStorage(context, 'profilePic/$uid', profileImage);
      }

      UserModel userModel = UserModel(
        name: name,
        uid: uid,
        profileUrl: profileUrl,
        isOnline: true,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber!,
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
}
