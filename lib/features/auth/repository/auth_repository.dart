import 'dart:io';
import 'package:bit_messenger/common/constants.dart';
import 'package:bit_messenger/common/providers/firebase_providers.dart';
import 'package:bit_messenger/common/providers/storage_repository_provider.dart';
import 'package:bit_messenger/common/utils.dart';
import 'package:bit_messenger/features/auth/screens/otp_screen.dart';
import 'package:bit_messenger/features/auth/screens/user_info_screen.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:bit_messenger/screens/mobile_screen_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.firebaseAuth,
    required this.firestore,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message!);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OTPScreen(id: verificationId)),
          );
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
            .read(storageRepositoryProvider)
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
        MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        text: e.message!,
      );
    }
  }

  Future<UserModel?> getUserData() async {
    var userData = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    UserModel? userModel;
    if (userData.data() != null) {
      userModel = UserModel.fromMap(userData.data()!);
    }
    return userModel;
  }
}
